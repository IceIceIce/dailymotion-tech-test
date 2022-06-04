//
//  VideosListPresenter.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation
import UIKit

protocol VideosListPresenter: AnyObject {

    var view: VideosListView? { get set }
    var viewModel: VideosListLoadedViewModel? { get }

    func start()
}

final class DefaultVideosListPresenter: VideosListPresenter {

    private enum State {
        case idle
        case loaded
        case loading
    }

    weak var view: VideosListView?
    var viewModel: VideosListLoadedViewModel?

    private let interactor: VideosListInteractor
    private let errorManager: ErrorManager
    private let imageCache: ImageCaching
    private let creationDateFormatter: CompatibilityFormatter

    private var state: State = .idle {
        didSet {
            guard state != oldValue else { return }
            switch state {
            case .idle:
                break
            case .loaded:
                view?.showContent()
            case .loading:
                view?.showLoading()
            }
        }
    }

    init(interactor: VideosListInteractor,
         errorManager: ErrorManager,
         imageCache: ImageCaching = ImageCache.shared) {

        self.interactor = interactor
        self.errorManager = errorManager
        self.imageCache = imageCache
        if #available(iOS 13.0, *) {
            creationDateFormatter = RelativeDateTimeFormatter()
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("dd MMMM")
            creationDateFormatter = dateFormatter
        }
    }

    func start() {

        state = .loading
        interactor.fetchVideos() { [weak self] result in

            switch result {
            case .success(let videos):
                self?.handleSuccess(videos: videos)

            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
}

extension DefaultVideosListPresenter {

    private func handleSuccess(videos: [Video]) {

        let tableViewModel: [VideoCell.ViewModel] = videos.map { video in

            let imageFetcher = { [weak self] (setImage: @escaping VideoCell.ImageSetter) in
                if let thumbnail = self?.imageCache[video.thumbnailUrl] {
                    setImage(video.thumbnailUrl, thumbnail)
                    return
                }
                let defaultImage = UIImage(named: "placeholder")
                self?.interactor.fetchThumbnail(url: video.thumbnailUrl, completion: { error in
                    if let error = error {
                        self?.handleError(error)
                        return
                    }
                    setImage(video.thumbnailUrl, self?.imageCache[video.thumbnailUrl] ?? defaultImage)
                })
                setImage(video.thumbnailUrl, defaultImage)
            }

            return VideoCell.ViewModel(title: video.title,
                                       description: video.description,
                                       creationTime: creationDateFormatter.format(date: video.creationTime),
                                       thumbnailUrl: video.thumbnailUrl,
                                       imageFetcher: imageFetcher)
        }

        viewModel = .loaded(rows: tableViewModel)
        state = .loaded
    }

    private func handleError(_ error: Error) {

        let sortedError = errorManager.sortError(error)
        guard case let .medium(displayableErrorViewModel) = sortedError else {

            return
        }
        let emptyViewModel = EmptyView.ViewModel(text: displayableErrorViewModel.message,
                                                 refreshButtonTitle: "Reload")

        viewModel = .empty(emptyViewModel)
        state = .loaded
    }
}
