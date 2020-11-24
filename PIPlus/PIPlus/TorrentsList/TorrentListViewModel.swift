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
    @Published var filterState: FilterStateViewState
    private let torrentSearcher: TorrentSearcher
    private let torrentDownloader: TorrentDownloader
    private let filterManager: FilterManager
    
    init(torrentSearcher: TorrentSearcher,
         torrentDownloader: TorrentDownloader,
         filterManager: FilterManager) {
        self.torrentSearcher = torrentSearcher
        self.torrentDownloader = torrentDownloader
        self.filterManager = filterManager
        self.filterState = filterManager.loadLastFilter()
    }
    
    func loadTorrents() {
        isLoading = true
        torrents = [TorrentDetail]()
        filterManager.saveFilter(filterState)
        switch filterState.type {
        case .tv:
            torrentSearcher.series(self.torrentSearchParams(), torrentSearchResultHandler)
        case .film:
            torrentSearcher.movies(self.torrentSearchParams(), torrentSearchResultHandler)
        }
    }
    
    func download(_ torrent: TorrentDetail) {
        isLoading = true
        let params = DownloadTorrentParams(category: filterState.type.rawValue, url: torrent.downloadURL)
        torrentDownloader.downloadTorrent(params: params) { (result) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .failure(let error):
                    print(error)
                case .success(_):
                    self.isAlertShowing = true
                }
            }
        }
    }
    
    private func torrentSearchResultHandler(_ result: Result<[Torrent], Error>) {
        isLoading = false
        switch result {
        case .failure(let error):
            DispatchQueue.main.async {
                print(error)
            }
        case .success(let torrents):
            DispatchQueue.main.async {
                self.torrents = torrents.map {
                    TorrentDetail(name: $0.title,
                                  date: $0.date,
                                  size: $0.size,
                                  downloadURL: $0.download)
                }
            }
        }
    }
    
    private func torrentSearchParams() -> TorrentSearchParams {
        let category: TorrentSearchParams.Category
        switch filterState.language {
        case .en:
            category = .en
        case .hu:
            category = .hu
        }
        
        return TorrentSearchParams(category: category,
                                   query: searchQuery)
    }
}
