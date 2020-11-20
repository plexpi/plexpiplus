//
//  FilterViewState.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 11. 04..
//

import Foundation

struct FilterViewState {
    enum Category: String {
        case series = "series"
        case movies = "movies"
    }

    enum Language: String {
        case en = "en"
        case hu = "hu"
    }
    
    static let `default` = FilterViewState(category: .series, language: .en)
    
    var category: Category
    var language: Language
}
