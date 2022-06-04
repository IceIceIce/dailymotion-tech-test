//
//  VideosListInteractor.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation
import UIKit

protocol VideosListInteractor: AnyObject {

    func fetchVideos(completion: @escaping (Result<[Video], DataProviderError>) -> Void)
    func fetchThumbnail(url: URL, completion: @escaping (Error?) -> Void)
}

enum VideosListInteractorError: Error {
    case couldNotGetImageFromData(URL)
}

final class DefaultVideosListInteracor: VideosListInteractor {

    private let dataProvider: DataProvider
    private let videosPerPage: Int
    private let imageCache: ImageCaching

    init(dataProvider: DataProvider,
         videosPerPage: Int = 20,
         imageCache: ImageCaching = ImageCache.shared) {

        self.dataProvider = dataProvider
        self.videosPerPage = videosPerPage
        self.imageCache = imageCache
    }

    func fetchVideos(completion: @escaping (Result<[Video], DataProviderError>) -> Void) {

        dataProvider.fetchVideos(videosPerPage: videosPerPage) { result in

            switch result {
            case .success(let page):
                completion(.success(page.list))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchThumbnail(url: URL, completion: @escaping (Error?) -> Void) {

        dataProvider.fetchData(url: url) { [weak self] result in
            
            switch result {
            case .success(let image):
                if let image = UIImage(data: image) {
                    self?.imageCache[url] = image
                    completion(nil)
                } else {
                    completion(VideosListInteractorError.couldNotGetImageFromData(url))
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
}
