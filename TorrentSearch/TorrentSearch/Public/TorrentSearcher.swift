//
//  TorrentSearch.swift
//  TorrentSearch
//
//  Created by Adam Borbas on 2020. 10. 25..
//

import Foundation
import Combine

public protocol TorrentSearcher {
    func series(_ params: TorrentSearchParams) -> AnyPublisher<[Torrent], Error>
    func movies(_ params: TorrentSearchParams) -> AnyPublisher<[Torrent], Error>
}
