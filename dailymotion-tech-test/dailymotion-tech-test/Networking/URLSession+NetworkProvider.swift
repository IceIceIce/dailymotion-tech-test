//
//  URLSession+NetworkProvider.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation

extension URLSession: NetworkProvider {

    func process<T: Decodable>(request: URLRequest, decoder: JSONDecoder, completion: @escaping (Result<T, NetworkError>) -> Void) {

        startDataTask(with: request) { (result: Result<Data, NetworkError>) in

            switch result {
            case .success(let data):
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(NetworkError.parsing(error)))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func download(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        startDataTask(with: request, completion: completion)
    }
}

extension URLSession {

    private func startDataTask(with request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {

        dataTask(with: request) { (data, response, error) in

            if let error = error {
                completion(.failure(.networking(error)))
                return
            }

            if let response = response as? HTTPURLResponse, !(200...399).contains(response.statusCode) {
                completion(.failure(.server(statusCode: response.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData(request)))
                return
            }

            completion(.success(data))

        }.resume()
    }
}
