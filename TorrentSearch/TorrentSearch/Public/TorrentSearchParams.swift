//
//  TorrentSearchParam.swift
//  TorrentSearch
//
//  Created by Adam Borbas on 2020. 10. 25..
//

import Foundation

public struct TorrentSearchParams {
    public enum Category: String {
        case en = "en"
        case hu = "hu"
    }
    
    public let category: Category
    public let query: String
    
    public init(category: Category, query: String) {
        self.category = category
        self.query = query
    }
}
