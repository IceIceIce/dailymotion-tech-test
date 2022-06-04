//
//  Video.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation

struct Video: Codable {

    enum CodingKeys: String, CodingKey, CaseIterable {
        case id = "id"
        case description = "description"
        case thumbnailUrl = "thumbnail_120_url"
        case url = "url"
        case creationTime = "created_time"
        case title = "title"
    }

    let id: String
    let description: String
    let thumbnailUrl: URL
    let url: URL
    let creationTime: Date
    let title: String
}
