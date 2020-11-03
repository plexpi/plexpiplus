//
//  Torrent.swift
//  TorrentSearch
//
//  Created by Adam Borbas on 2020. 10. 25..
//

import Foundation

public struct Torrent: Codable {
    public let title: String
    public let id: String
    public let key: String
    public let size: String
    public let type: String
    public let date: String
    public let download: String
}
