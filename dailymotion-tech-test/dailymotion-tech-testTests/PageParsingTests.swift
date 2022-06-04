//
//  PageParsingTests.swift
//  dailymotion-tech-testTests
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import XCTest
@testable import dailymotion_tech_test

class PageParsingTests: XCTestCase {

    var page: Page!

    override func setUpWithError() throws {
        let pageData = Mocks.loadFile(name: "Page", type: "json")
        page = try JSONHandling.decoder.decode(Page.self, from: pageData)
    }

    func testVideosParsing() throws {

        XCTAssertEqual(page.list.count, 2)

        XCTAssertEqual(page.list[0].description, "")
        XCTAssertEqual(page.list[0].thumbnailUrl, URL(string: "https://s2.dmcdn.net/v/T-9cR1YcqjIewDQN6/x120"))
        XCTAssertEqual(page.list[0].url, URL(string: "https://www.dailymotion.com/video/x8bdfa3"))
        XCTAssertEqual(page.list[0].creationTime, Date(timeIntervalSince1970: 1654344530))
        XCTAssertEqual(page.list[0].title, "PlayerFeature_FUNINO")
        XCTAssertEqual(page.list[0].id, "x8bdfa3")


        XCTAssertEqual(page.list[1].description, "Das Video zeigt die ersten 10 Minuten aus Lego Star Wars 3: The Clone Wars und damit die Prolog-Mission des Actionspiels. Die Szenen stammen aus der Xbox-360-Version.")
        XCTAssertEqual(page.list[1].thumbnailUrl, URL(string: "https://s1.dmcdn.net/v/T-AN61YcqgK6rj0LE/x120"))
        XCTAssertEqual(page.list[1].url, URL(string: "https://www.dailymotion.com/video/x8bdhom"))
        XCTAssertEqual(page.list[1].creationTime, Date(timeIntervalSince1970: 1654344277))
        XCTAssertEqual(page.list[1].title, "Lego Star Wars 3: The Clone Wars - Prolog-Mission - Die ersten 10-Minuten")
        XCTAssertEqual(page.list[1].id, "x8bdhom")
    }
}
