//
//  TorrentDownloader.swift
//  TorrentDownloader
//
//  Created by Adam Borbas on 2020. 10. 27..
//

import Foundation
import Combine

public protocol TorrentDownloader {
    func downloadTorrent(params: DownloadTorrentParams) -> AnyPublisher<String, Error>
}
