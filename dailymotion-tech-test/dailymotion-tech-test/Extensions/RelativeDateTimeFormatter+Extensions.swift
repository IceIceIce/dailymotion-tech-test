//
//  RelativeDateTimeFormatter+Extensions.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation

@available(iOS 13.0, *)
extension RelativeDateTimeFormatter: CompatibilityFormatter {

    func format(date: Date) -> String {
        localizedString(for: date, relativeTo: Date())
    }
}
