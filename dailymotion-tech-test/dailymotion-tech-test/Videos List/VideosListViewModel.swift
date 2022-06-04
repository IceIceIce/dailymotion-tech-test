//
//  VideosListViewModel.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation

enum VideosListLoadedViewModel {

    case loaded(rows: [VideoCell.ViewModel])
    case empty(EmptyView.ViewModel)
}
