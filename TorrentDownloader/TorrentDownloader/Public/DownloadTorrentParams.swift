//
//  DownloadTorrentParams.swift
//  TorrentDownloader
//
//  Created by Adam Borbas on 2020. 11. 25..
//

import Foundation

public struct DownloadTorrentParams: Encodable {
        
    public enum Category: String, Encodable {
        case movies = "movies"
        case series = "series"
    }
    
    public let category: Category
    public let url: String
    
    public init(category: Category, url: String) {
        self.category = category
        self.url = url
    }
}
