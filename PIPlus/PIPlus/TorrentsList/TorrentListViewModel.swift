//
//  TorrentListViewModel.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 11. 23..
//

import Foundation
import TorrentSearch
import TorrentDownloader

class TorrentListViewModel: ObservableObject {
    @Published var torrents = [TorrentDetail]()
    @Published var searchQuery = ""
    @Published var isLoading = false
    @Published var isAlertShowing = false
    @Published var filterState: FilterStateViewState = FilterStateViewState(filter: TorrentFilter.default)
}
