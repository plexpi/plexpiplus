//
//  TorrentFilter.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 11. 25..
//

import Foundation

struct TorrentFilter {
    static let `default` = TorrentFilter(type: .tv, language: .en)
    
    let type: TorrentType
    let language: TorrentLanguage
}
