//
//  TorrentSearch.swift
//  TorrentSearch
//
//  Created by Adam Borbas on 2020. 10. 25..
//

import Foundation

public protocol TorrentSearcher {
    func series(_ params: TorrentSearchParams, _ completionHandler: @escaping (Result<[Torrent], Error>) -> ())
    func movies(_ params: TorrentSearchParams, _ completionHandler: @escaping (Result<[Torrent], Error>) -> ())
}
