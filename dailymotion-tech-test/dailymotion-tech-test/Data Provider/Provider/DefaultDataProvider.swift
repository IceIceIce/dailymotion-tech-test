//
//  DefaultDataProvider.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation

final class DefaultDataProvider: DataProvider {

    private let decoder: JSONDecoder
    private let networkProvider: NetworkProvider
    private let requestBuilder = RequestBuilder()

    private var credentials: String?

    init(decoder: JSONDecoder = JSONDecoder(),
         networkProvider: NetworkProvider = URLSession.shared) {

        self.decoder = decoder
        self.networkProvider = networkProvider
    }

    func fetchVideos(videosPerPage: Int, completion: @escaping (Result<Page, DataProviderError>) -> Void) {

        let fields = Video.CodingKeys.allCases.map(\.rawValue).joined(separator: ",")
        fetch(requestType: .fetchVideos, path: "videos", parameters: ["limit": "\(videosPerPage)", "fields": fields], completion: completion)
    }

    func fetchData(url: URL, completion: @escaping (Result<Data, DataProviderError>) -> Void) {

        let request = self.requestBuilder.buildURLRequest(url: url, method: .get)
        networkProvider.download(request: request) { (result: Result<Data, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(DataProviderError(request: .url(url), cause: error)))
                }
            }
        }
    }
}

extension DefaultDataProvider {

    private func fetch<T: Decodable>(requestType: DataProviderRequest,
                                     path: String = "",
                                     parameters: Dictionary<String, String> = [:],
                                     completion:  @escaping (Result<T, DataProviderError>) -> Void) {

        do {
            let url = try self.requestBuilder.buildURL(path: path, parameters: parameters)
            let request = self.requestBuilder.buildURLRequest(url: url, method: .get)

            networkProvider.process(request: request, decoder: decoder) { (result: Result<T, NetworkError>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let success):
                        completion(.success(success))
                    case .failure(let error):
                        completion(.failure(DataProviderError(request: requestType, cause: error)))
                    }
                }
            }
        } catch {
            let error = DataProviderError(request: requestType, cause: error)
            completion(.failure(error))
        }
    }
}
