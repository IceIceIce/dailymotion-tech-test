//
//  AppRouter.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation
import UIKit

protocol AppRouter: ErrorHandler {

    var window: UIWindow? { get }

    func start()
    func openVideo(title: String, url: URL)
}
