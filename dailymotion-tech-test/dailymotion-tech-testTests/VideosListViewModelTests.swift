//
//  VideosListViewModelTests.swift
//  dailymotion-tech-testTests
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import XCTest
@testable import dailymotion_tech_test

class VideosListViewModelTests: XCTestCase {

    var page: Page!

    override func setUpWithError() throws {
        let pageData = Mocks.loadFile(name: "Page", type: "json")
        page = try JSONHandling.decoder.decode(Page.self, from: pageData)
    }

    func testErrorState() {

        let failure: Result<Page, DataProviderError> = .failure(DataProviderError(request: .fetchVideos,
                                                                                  cause: NetworkError.server(statusCode: 404)))
        let interactor = DefaultVideosListInteracor(dataProvider: DataProviderMock(result: failure))
        let presenter: VideosListPresenter = DefaultVideosListPresenter(interactor: interactor,
                                                                        errorManager: DefaultErrorManager(),
                                                                        router: RouterMock())
        presenter.start()

        guard case let .empty(viewModel) = presenter.viewModel else {
            XCTFail("Not correct view model type")
            return
        }
        XCTAssertEqual(viewModel.text, "Not found")
        XCTAssertEqual(viewModel.refreshButtonTitle, "Reload")
    }

    func testVideosListState() {

        let success: Result<Page, DataProviderError> = .success(page)
        let interactor = DefaultVideosListInteracor(dataProvider: DataProviderMock(result: success))
        let presenter: VideosListPresenter = DefaultVideosListPresenter(interactor: interactor,
                                                                        errorManager: DefaultErrorManager(),
                                                                        router: RouterMock())
        presenter.start()

        guard case let .loaded(viewModel) = presenter.viewModel else {
            XCTFail("Not correct view model type")
            return
        }
        XCTAssertEqual(viewModel.count, 2)

        let compatibilityFormatter = DefaultCompatibilityFormatter()

        XCTAssertEqual(viewModel[0].creationTime, compatibilityFormatter.format(date: page.list[0].creationTime))
        XCTAssertEqual(viewModel[0].thumbnailUrl, page.list[0].thumbnailUrl)
        XCTAssertEqual(viewModel[0].url, page.list[0].url)
        XCTAssertEqual(viewModel[0].title, page.list[0].title)
        XCTAssertEqual(viewModel[0].description, page.list[0].description)

        XCTAssertEqual(viewModel[1].creationTime, compatibilityFormatter.format(date: page.list[1].creationTime))
        XCTAssertEqual(viewModel[1].thumbnailUrl, page.list[1].thumbnailUrl)
        XCTAssertEqual(viewModel[1].url, page.list[1].url)
        XCTAssertEqual(viewModel[1].title, page.list[1].title)
        XCTAssertEqual(viewModel[1].description, page.list[1].description)
    }
}
