//
//  MainViewState.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 11. 04..
//

import Foundation

enum MainViewState {
    case loading
    case error(message: String)
    case success(MainViewSuccessState)
    case downloading(name: String)
}

struct MainViewSuccessState {
    let torrents: [TorrentViewCellState]
}

struct TorrentViewCellState {
    let title: String
    let date: String
    let size: String
    let downloadURL: String
}
