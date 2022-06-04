//
//  AppDelegate.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ app: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            return try Date(timeIntervalSince1970: container.decode(TimeInterval.self))
        }
        let dataProvider = DefaultDataProvider(decoder: decoder)
        let interactor = DefaultVideosListInteracor(dataProvider: dataProvider)
        let errorManager = DefaultErrorManager()
        let presenter = DefaultVideosListPresenter(interactor: interactor, errorManager: errorManager)
        let videosListController = VideosListViewController(presenter: presenter)

        window.rootViewController = UINavigationController(rootViewController: videosListController)
        window.makeKeyAndVisible()

        return true
    }


}

