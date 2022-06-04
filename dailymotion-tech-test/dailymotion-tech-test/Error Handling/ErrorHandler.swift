//
//  ErrorHandler.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation

protocol ErrorHandler: AnyObject {

    func handleError(_ error: ErrorLevel)
}
