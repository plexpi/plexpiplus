//
//  TorrentsListPresenter.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 11. 25..
//

import Foundation
import TorrentSearch
import TorrentDownloader
import Combine

class TorrentsListPresenter: ObservableObject {
    private let torrentSearcher: TorrentSearcher
    private let torrentDownloader: TorrentDownloader
    private let filterManager: FilterManager
    @Published private(set) var viewModel = TorrentListViewModel()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(torrentSearcher: TorrentSearcher,
         torrentDownloader: TorrentDownloader,
         filterManager: FilterManager) {
        self.torrentSearcher = torrentSearcher
        self.torrentDownloader = torrentDownloader
        self.filterManager = filterManager
    }
    
    func loadFilterState() {
        viewModel.filterState = FilterStateViewState(filter: filterManager.loadLastFilter())
    }
    
    func loadTorrents() {
        viewModel.isLoading = true
        viewModel.torrents = [TorrentDetail]()
        filterManager.saveFilter(viewModel.filterState.torrentFilter)
        
        subscriptions.forEach { $0.cancel() }
        subscriptions = []
        
        switch viewModel.filterState.type {
        case .tv:
            handleTorrentsResult(torrentSearcher.series(self.torrentSearchParams()))
        case .film:
            handleTorrentsResult(torrentSearcher.movies(self.torrentSearchParams()))
        }
    }
    
    func download(_ torrent: TorrentDetail) {
        viewModel.isLoading = true
        let params = downloadTorrentParams(type: viewModel.filterState.type, url: torrent.downloadURL)
        _ = torrentDownloader.downloadTorrent(params: params)
            .subscribe(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { error in
                    self.viewModel.isLoading = false
                    print(error)
                }, receiveValue: { result in
                    self.viewModel.isAlertShowing = true
                })
    }
    
    private func downloadTorrentParams(type: TorrentType, url: String) -> DownloadTorrentParams {
        let category: DownloadTorrentParams.Category
        switch type {
        case .film:
            category = .movies
        case .tv:
            category = .series
        }
        return DownloadTorrentParams(category: category, url: url)
    }
    
    private func handleTorrentsResult(_ publisher: AnyPublisher<[Torrent], Error>) {
        publisher
            .subscribe(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { error in
                    self.viewModel.isLoading = false
                }, receiveValue: {
                    self.viewModel.torrents = $0.map { self.mapToTorrentDetail($0) }
                })
            .store(in: &subscriptions)
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
    
    private func mapToTorrentDetail(_ torrent: Torrent) -> TorrentDetail {
        return TorrentDetail(name: torrent.title,
                             date: torrent.date,
                             size: torrent.size,
                             downloadURL: torrent.download)
    }
}

private extension FilterStateViewState {
    var torrentFilter: TorrentFilter {
        return TorrentFilter(type: self.type, language: self.language)
    }
}
