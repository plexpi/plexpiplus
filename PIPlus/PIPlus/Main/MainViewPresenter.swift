//
//  MainViewPresenter.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 10. 26..
//

import Foundation
import TorrentSearch
import TorrentDownloader

enum TorrentType {
    case series
    case movie
}

enum TorrentLanguage {
    case en
    case hu
}

struct SearchParams {
    let tpye: TorrentType
    let query: String
    let language: TorrentLanguage
}

protocol MainView: class {
    func render(_ state: MainViewState)
}

class MainViewPresenter {
    private unowned let view: MainView
    private let torrentSearcher: TorrentSearcher
    private let torrentDownloader: TorrentDownloader
    private let filterManager: FilterManager
    
    private var filters: FilterViewState {
        return filterManager.loadLastFilter()
    }
    
    init(view: MainView,
         torrentSearcher: TorrentSearcher,
         torrentDownloader: TorrentDownloader,
         filterManager: FilterManager) {
        self.view = view
        self.torrentSearcher = torrentSearcher
        self.torrentDownloader = torrentDownloader
        self.filterManager = filterManager
    }
    
    func search(query: String) {
        view.render(.loading)
        loadTorrents(query)
    }
    
    func download(_ torrent: TorrentViewCellState) {
        view.render(.loading)
        let params = DownloadTorrentParams(category: filters.category.rawValue, url: torrent.downloadURL)
        torrentDownloader.downloadTorrent(params: params) { (result) in
            switch result {
            case .failure(let error):
                self.view.render(.error(message: error.localizedDescription))
            case .success(_):
                self.view.render(.downloading(name: torrent.title))
            }
        }
    }
    
    private func loadTorrents(_ query: String) {
        switch filters.category {
        case .series:
            torrentSearcher.series(self.torrentSearchParams(query: query, language: filters.language), torrentSearchResultHandler)
        case .movies:
            torrentSearcher.movies(self.torrentSearchParams(query: query, language: filters.language), torrentSearchResultHandler)
        }
    }
    
    private func torrentSearchResultHandler(_ result: Result<[Torrent], Error>) {
        switch result {
        case .failure(let error):
            DispatchQueue.main.async {
                self.view.render(.error(message: error.localizedDescription))
            }
        case .success(let torrents):
            DispatchQueue.main.async {
                let state = MainViewSuccessState(torrents: torrents.map({ TorrentViewCellState($0) }))
                self.view.render(.success(state))
            }
        }
    }
    
    private func torrentSearchParams(query: String, language: FilterViewState.Language) -> TorrentSearchParams {
        let category: TorrentSearchParams.Category
        switch language {
        case .en:
            category = .en
        case .hu:
            category = .hu
        }
        
        return TorrentSearchParams(category: category,
                                   query: query)
    }
}

extension TorrentViewCellState {
    init(_ torrent: Torrent){
        self.date = torrent.date
        self.size = torrent.size
        self.title = torrent.title
        self.downloadURL = torrent.download
    }
}
