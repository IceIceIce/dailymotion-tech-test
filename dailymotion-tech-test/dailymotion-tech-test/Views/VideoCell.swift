//
//  VideoCell.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation
import UIKit

final class VideoCell: UITableViewCell {

    typealias ImageSetter = (URL, UIImage?) -> Void

    static let identifier = "VideoCell"

    private let mainContainerStack = UIStackView()

    private let thumbnailTitleContainer = UIStackView()
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()

    private let descriptionLabel = UILabel()
    private let creationTimeLabel = UILabel()

    private var thumbnailUrl: URL?
    private var fetchImage: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupMainContainerStack()
        setupThumbnailTitleContainer()
        setupThumbnailImageView()
        setupTitleLabel()
        setupDescriptionLabel()
        setupCreationTimeLabel()
        setupAutoLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupMainContainerStack() {

        mainContainerStack.translatesAutoresizingMaskIntoConstraints = false
        mainContainerStack.spacing = Constants.inset
        mainContainerStack.axis = .vertical
        contentView.addSubview(mainContainerStack)
    }

    private func setupThumbnailTitleContainer() {

        thumbnailTitleContainer.axis = .horizontal
        thumbnailTitleContainer.spacing = Constants.inset
        mainContainerStack.addArrangedSubview(thumbnailTitleContainer)
    }

    private func setupThumbnailImageView() {

        thumbnailImageView.contentMode = .scaleAspectFit
        let thumbnailContainer = UIStackView()
        thumbnailContainer.axis = .vertical
        thumbnailContainer.addArrangedSubview(thumbnailImageView)
        thumbnailContainer.addArrangedSubview(UIView()) // Spacer
        thumbnailTitleContainer.addArrangedSubview(thumbnailContainer)
    }

    private func setupTitleLabel() {

        titleLabel.font = .preferredFont(forTextStyle: .title3)
        titleLabel.numberOfLines = 0
        let titleContainer = UIStackView()
        titleContainer.axis = .vertical
        titleContainer.addArrangedSubview(titleLabel)
        titleContainer.addArrangedSubview(UIView()) // Spacer
        thumbnailTitleContainer.addArrangedSubview(titleContainer)
    }

    private func setupDescriptionLabel() {

        descriptionLabel.numberOfLines = 0
        creationTimeLabel.font = .preferredFont(forTextStyle: .footnote)
        mainContainerStack.addArrangedSubview(descriptionLabel)
    }

    private func setupCreationTimeLabel() {

        creationTimeLabel.font = .preferredFont(forTextStyle: .caption1)
        mainContainerStack.addArrangedSubview(creationTimeLabel)
    }

    private func setupAutoLayout() {

        let thumbnailHeightConstraint = thumbnailImageView.heightAnchor.constraint(equalToConstant: Constants.videoThumbnailImageHeight)
        thumbnailHeightConstraint.priority = .defaultHigh

        let constraints = [
            mainContainerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.inset),
            mainContainerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.inset),
            mainContainerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.inset),
            mainContainerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.inset),

            thumbnailImageView.widthAnchor.constraint(equalToConstant: Constants.videoThumbnailImageWidth),
            thumbnailHeightConstraint
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension VideoCell {

    struct ViewModel {

        let title: String
        let description: String
        let creationTime: String
        let thumbnailUrl: URL
        let imageFetcher: (@escaping ImageSetter) -> Void
        let url: URL
    }

    func configure(with viewModel: VideoCell.ViewModel) {

        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        creationTimeLabel.text = viewModel.creationTime
        thumbnailUrl = viewModel.thumbnailUrl
        fetchImage = { [weak self] () in
            viewModel.imageFetcher { (thumbnailUrl, thumbnail) in
                guard self?.thumbnailUrl == thumbnailUrl else { return }
                self?.thumbnailImageView.image = thumbnail
            }
        }
        fetchImage?()
    }
}

