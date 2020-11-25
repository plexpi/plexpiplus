//
//  TorrentsListPresenter.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 11. 25..
//

import Foundation
import TorrentSearch
import TorrentDownloader

protocol TorrentsListPresenting {
    func loadTorrents()
}

class TorrentsListPresenter: ObservableObject {
    private let torrentSearcher: TorrentSearcher
    private let torrentDownloader: TorrentDownloader
    private let filterManager: FilterManager
    @Published private(set) var viewModel = TorrentListViewModel()
    
    init(torrentSearcher: TorrentSearcher,
         torrentDownloader: TorrentDownloader,
         filterManager: FilterManager) {
        self.torrentSearcher = torrentSearcher
        self.torrentDownloader = torrentDownloader
        self.filterManager = filterManager
    }
    
    func loadFilterState() {
        viewModel.filterState = filterManager.loadLastFilter()
    }
    
    func loadTorrents() {
        viewModel.isLoading = true
        viewModel.torrents = [TorrentDetail]()
        filterManager.saveFilter(viewModel.filterState)
        switch viewModel.filterState.type {
        case .tv:
            torrentSearcher.series(self.torrentSearchParams(), torrentSearchResultHandler)
        case .film:
            torrentSearcher.movies(self.torrentSearchParams(), torrentSearchResultHandler)
        }
    }
    
    func download(_ torrent: TorrentDetail) {
        viewModel.isLoading = true
        let params = DownloadTorrentParams(category: viewModel.filterState.type.rawValue, url: torrent.downloadURL)
        torrentDownloader.downloadTorrent(params: params) { (result) in
            DispatchQueue.main.async {
                self.viewModel.isLoading = false
                switch result {
                case .failure(let error):
                    print(error)
                case .success(_):
                    self.viewModel.isAlertShowing = true
                }
            }
        }
    }
    
    private func torrentSearchResultHandler(_ result: Result<[Torrent], Error>) {
        viewModel.isLoading = false
        switch result {
        case .failure(let error):
            DispatchQueue.main.async {
                print(error)
            }
        case .success(let torrents):
            DispatchQueue.main.async {
                self.viewModel.torrents = torrents.map {
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
        switch viewModel.filterState.language {
        case .en:
            category = .en
        case .hu:
            category = .hu
        }
        
        return TorrentSearchParams(category: category,
                                   query: viewModel.searchQuery)
    }
}
