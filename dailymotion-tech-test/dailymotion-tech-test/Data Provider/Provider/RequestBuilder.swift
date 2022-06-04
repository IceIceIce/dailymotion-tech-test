//
//  RequestBuilder.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation

struct RequestBuilder {

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }

    enum BuilderError: Error {
        case couldNotBuildURL(parameters: Dictionary<String, String>)
    }

    private let baseComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = ""
        components.path = "/api/"
        return components
    }()

    func buildURL(path: String = "", parameters: Dictionary<String, String>) throws -> URL {

        var components = baseComponents
        components.path += path
        components.queryItems = [URLQueryItem]()
        parameters.forEach({ (key, value) in
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        })
        guard let url = components.url else {
            throw BuilderError.couldNotBuildURL(parameters: parameters)
        }
        return url
    }

    func buildURLRequest(url: URL, method: HTTPMethod) -> URLRequest {

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
