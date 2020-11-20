//
//  FilterManager.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 10. 27..
//

import Foundation

protocol FilterManager {
    func saveFilter(_ filter: FilterViewState)
    func loadLastFilter() -> FilterViewState
}
