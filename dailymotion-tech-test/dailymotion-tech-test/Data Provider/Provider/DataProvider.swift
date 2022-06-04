//
//  DataProvider.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation

protocol DataProvider: AnyObject {

    func fetchVideos(videosPerPage: Int, completion: @escaping (Result<Page, DataProviderError>) -> Void)
    func fetchData(url: URL, completion: @escaping (Result<Data, DataProviderError>) -> Void)
}
