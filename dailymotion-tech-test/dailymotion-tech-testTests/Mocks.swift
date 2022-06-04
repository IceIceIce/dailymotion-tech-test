//
//  Mocks.swift
//  dailymotion-tech-testTests
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation
import UIKit
@testable import dailymotion_tech_test

class Mocks {

    static func loadFile(name: String, type: String) -> Data {

        final class BundleFinder {}

        let bundle = Bundle(for: BundleFinder.self)
        let fileWithoutExtension = (name as NSString).deletingPathExtension

        guard let path = bundle.path(forResource: fileWithoutExtension, ofType: type) else {
            preconditionFailure("Cannot construct bundle path for file \"\(fileWithoutExtension)\" of type \"\(type)\"")
        }

        guard FileManager.default.fileExists(atPath: path) else {
            preconditionFailure("File doesn't exist at path \(path)")
        }

        do {
            return try Data(contentsOf: URL(fileURLWithPath: path))
        } catch {
            preconditionFailure("Could not read file at path \(path)")
        }
    }
}

final class DataProviderMock: DataProvider {

    let result: Result<Page, DataProviderError>

    init(result: Result<Page, DataProviderError>) {
        self.result = result
    }

    func fetchVideos(videosPerPage: Int, completion: @escaping (Result<Page, DataProviderError>) -> Void) {
        completion(result)
    }

    func fetchData(url: URL, completion: @escaping (Result<Data, DataProviderError>) -> Void) {
        completion(.success(Data()))
    }
}

final class RouterMock: AppRouter {

    var window: UIWindow?

    func handleError(_ error: ErrorLevel) {

    }

    func start() {

    }

    func openVideo(title: String, url: URL) {

    }
}
