//
//  CompatibilityFormatter.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation

protocol CompatibilityFormatter {

    func format(date: Date) -> String
}

struct DefaultCompatibilityFormatter: CompatibilityFormatter {

    private let formatter: CompatibilityFormatter

    init() {

        if #available(iOS 13.0, *) {
            formatter = RelativeDateTimeFormatter()
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("dd MMMM")
            formatter = dateFormatter
        }
    }

    func format(date: Date) -> String {
        formatter.format(date: date)
    }
}
