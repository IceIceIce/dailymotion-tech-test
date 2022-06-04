//
//  JSONHandling.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation

struct JSONHandling {

    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            return try Date(timeIntervalSince1970: container.decode(TimeInterval.self))
        }
        return decoder
    }
}
