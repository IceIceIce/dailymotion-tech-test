//
//  DefaultErrorReporter.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation

struct DefaultErrorReporter: ErrorReporter {


    // Would be Firebase or Sentry in a real app

    func reportError(_ error: Error) {
        print(error)
    }
}
