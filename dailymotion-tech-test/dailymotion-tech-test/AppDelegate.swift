//
//  AppDelegate.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var appRouter: AppRouter?

    func application(_ app: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            return try Date(timeIntervalSince1970: container.decode(TimeInterval.self))
        }
        let errorManager = DefaultErrorManager()
        let dataProvider = DefaultDataProvider(decoder: decoder)
        
        appRouter = DefaultAppRouter(dataProvider: dataProvider, errorManager: errorManager, window: window)
        appRouter?.start()

        return true
    }


}

