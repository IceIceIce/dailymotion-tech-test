//
//  ErrorLevel.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation

enum ErrorLevel {

    case critical(DisplayableErrorViewModel)
    case medium(DisplayableErrorViewModel)
    case low
}
