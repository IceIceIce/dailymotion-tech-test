//
//  DataProviderError.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation

struct DataProviderError: Error {

    let request: DataProviderRequest
    let cause: Error
}

enum DataProviderRequest {

    case fetchVideos
    case url(URL)
}
