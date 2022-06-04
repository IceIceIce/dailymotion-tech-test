//
//  DefaultAppRouter.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation
import UIKit
import SafariServices

final class DefaultAppRouter: AppRouter {

    var window: UIWindow?

    private let dataProvider: DataProvider
    private let errorManager: ErrorManager

    private var navigation: UINavigationController?

    init(dataProvider: DataProvider,
         errorManager: ErrorManager,
         window: UIWindow) {

        self.dataProvider = dataProvider
        self.errorManager = errorManager
        self.window = window
    }

    func start() {
        let interactor = DefaultVideosListInteracor(dataProvider: dataProvider)
        let presenter = DefaultVideosListPresenter(interactor: interactor,
                                                   errorManager: errorManager,
                                                   router: self)
        let navigation = UINavigationController(rootViewController: VideosListViewController(presenter: presenter))
        window?.rootViewController = navigation

        window?.makeKeyAndVisible()
        self.navigation = navigation
    }

    func openVideo(title: String, url: URL) {

        navigation?.pushViewController(WebViewController(title: title, url: url), animated: true)
    }

    func handleError(_ error: ErrorLevel) {

        guard case let .critical(displayableError) = error else { return }
        let alert = UIAlertController(title: displayableError.title, message: displayableError.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive))
        navigation?.present(alert, animated: true)
    }
}
