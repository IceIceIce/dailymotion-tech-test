//
//  ErrorManager.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation

protocol ErrorManager: AnyObject {

    func sortError(_ error: Error) -> ErrorLevel
    func reportError(_ error: Error)
}
