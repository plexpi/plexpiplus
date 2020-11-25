//
//  DownloadTorrentParams.swift
//  TorrentDownloader
//
//  Created by Adam Borbas on 2020. 11. 25..
//

import Foundation

public struct DownloadTorrentParams: Encodable {
    public let category: String
    public let url: String
    
    public init(category: String, url: String) {
        self.category = category
        self.url = url
    }
}
