//
//  NetworkProvider.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation

protocol NetworkProvider {

    func process<T: Decodable>(request: URLRequest, decoder: JSONDecoder, completion: @escaping (Result<T, NetworkError>) -> Void)
    func download(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void)
}
