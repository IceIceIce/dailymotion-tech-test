//
//  DefaultErrorManager.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation

final class DefaultErrorManager: ErrorManager {

    let errorReporter: ErrorReporter

    init(errorReporter: ErrorReporter = DefaultErrorReporter()) {
        self.errorReporter = errorReporter
    }

    func sortError(_ error: Error) -> ErrorLevel {

        reportError(error)

        if let dataProviderError = error as? DataProviderError {
            return handleDataProviderError(dataProviderError)
        }

        if let videosListInteractorError = error as? VideosListInteractorError {
            return handleVideosListInteractorError(videosListInteractorError)
        }

        return .low
    }

    func reportError(_ error: Error) {
        errorReporter.reportError(error)
    }
}

extension DefaultErrorManager {

    private func handleDataProviderError(_ dataProviderError: DataProviderError) -> ErrorLevel {

        if let networkError = dataProviderError.cause as? NetworkError {
            return handleNetworkError(networkError, request: dataProviderError.request)
        }

        if let builderError = dataProviderError.cause as? RequestBuilder.BuilderError {
            return handleRequestBuilderError(builderError)
        }

        return .low
    }

    private func handleNetworkError(_ networkError: NetworkError, request: DataProviderRequest) -> ErrorLevel {

        switch networkError {
        case .networking(let error):
            return .medium(DisplayableErrorViewModel(title: "Error", message: error.localizedDescription))
        case .noData, .parsing, .noImage:
            return .medium(DisplayableErrorViewModel(title: "Error", message: "Something went wrong, please try again later"))
        case .server(let statusCode):
            return handleServerError(statusCode: statusCode, request: request)
        }
    }

    private func handleServerError(statusCode: Int, request: DataProviderRequest) -> ErrorLevel {

        switch request {
        case .fetchVideos, .url:
            switch statusCode {
            case 401, 403:
                return .critical(DisplayableErrorViewModel(title: "Authentication", message: "You must login again"))
            case 404:
                return .medium(DisplayableErrorViewModel(title: "Error", message: "Not found"))
            default:
                return .medium(DisplayableErrorViewModel(title: "Error", message: "Something went wrong, please try again later"))
            }
        }
    }

    private func handleRequestBuilderError(_ builderError: RequestBuilder.BuilderError) -> ErrorLevel {
        return .medium(DisplayableErrorViewModel(title: "Error", message: "Something went wrong, please try again later"))
    }

    private func handleVideosListInteractorError(_ error: VideosListInteractorError) -> ErrorLevel {

        switch error {
        case .couldNotGetImageFromData:
            return .low
        }
    }
}
