//
//  FilterStateViewState.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 11. 25..
//

import SwiftUI

class FilterStateViewState: ObservableObject {
    @Published var type: TorrentType
    @Published var language: TorrentLanguage
    
    init(filter: TorrentFilter) {
        self.type = filter.type
        self.language = filter.language
    }
}
