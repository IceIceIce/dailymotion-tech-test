//
//  EmptyView.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation
import UIKit

final class EmptyView: UIView {

    private let vStack = UIStackView()
    private let textLabel = UILabel()
    private let refreshButton = UIButton(type: .system)

    var refreshButtonAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupVStack()
        setupTextLabel()
        setupRefreshButton()
        setupAutoLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupVStack() {

        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.spacing = Constants.inset
        addSubview(vStack)
    }

    private func setupTextLabel() {

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        vStack.addArrangedSubview(textLabel)
    }

    private func setupRefreshButton() {

        refreshButton.addTarget(self, action: #selector(pressedButton), for: .touchUpInside)
        vStack.addArrangedSubview(refreshButton)
    }

    private func setupAutoLayout() {

        let constraints = [
            vStack.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor),
            vStack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Constants.inset),
            vStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Constants.inset),
            vStack.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor),
            vStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            vStack.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    @objc private func pressedButton() {
        refreshButtonAction?()
    }
}

extension EmptyView {

    struct ViewModel {

        public let text: String
        public let refreshButtonTitle: String

        public init(text: String, refreshButtonTitle: String) {
            self.text = text
            self.refreshButtonTitle = refreshButtonTitle
        }
    }

    func configure(with viewModel: EmptyView.ViewModel) {

        textLabel.text = viewModel.text
        refreshButton.setTitle(viewModel.refreshButtonTitle, for: .normal)
    }
}
