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

        
        let errorManager = DefaultErrorManager()
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let session = URLSession(configuration: configuration)
        let dataProvider = DefaultDataProvider(decoder: JSONHandling.decoder, networkProvider: session)
        
        appRouter = DefaultAppRouter(dataProvider: dataProvider, errorManager: errorManager, window: window)
        appRouter?.start()

        return true
    }


}

