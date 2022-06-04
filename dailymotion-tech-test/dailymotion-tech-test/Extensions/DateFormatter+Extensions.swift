//
//  DateFormatter+Extensions.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation

extension DateFormatter: CompatibilityFormatter {

    func format(date: Date) -> String {
        string(from: date)
    }
}
