//
//  MainModuleResolver.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 11. 04..
//

import Foundation
import TorrentSearch
import TorrentDownloader

class MainModuleResolver: MainModule {
    static let shared = MainModuleResolver()
    
    func resolveTorrentsListPresenter() -> TorrentsListPresenter {
        return TorrentsListPresenter(torrentSearcher: resolveTorrentSearcher(),
                                     torrentDownloader: resolveTorrentDownloader(),
                                     filterManager: resolveFilterManager())
    }
    
    private func resolveTorrentSearcher() -> TorrentSearcher {
        return PITorrentSearcher(baseURL: URL(string: "http://raspberrypi.local:5000")!)
    }
    
    private func resolveTorrentDownloader() -> TorrentDownloader {
        return PITorrentDownloader(baseURL: URL(string: "http://raspberrypi.local:45780")!)
    }
    
    private lazy var filterManager: FilterManager = {
        return UserDefaultsFilterManager()
    }()
    private func resolveFilterManager() -> FilterManager {
        return filterManager
    }
}
