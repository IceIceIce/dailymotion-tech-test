//
//  NetworkError.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation

enum NetworkError: Error {

    case networking(Error)
    case noData(URLRequest)
    case noImage(Data)
    case parsing(Error)
    case server(statusCode: Int)
}
