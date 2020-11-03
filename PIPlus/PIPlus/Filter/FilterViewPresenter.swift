//
//  FilterViewPresenter.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 10. 27..
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

protocol FilterView: class {
    func render(_ state: FilterViewState)
}

class FilterViewPresenter {
    private unowned var view: FilterView
    private let filterManager: FilterManager
    
    private var state: FilterViewState!
    
    init(view: FilterView, filterManager: FilterManager) {
        self.view = view
        self.filterManager = filterManager
    }
    
    func loadState() {
        state = filterManager.loadLastFilter()
        view.render(state)
    }
    
    func setCategory(_ newCategory: FilterViewState.Category) {
        state.category = newCategory
    }

    func setLanguage(_ newLanguage: FilterViewState.Language) {
        state.language = newLanguage
    }
    
    func persistState() {
        filterManager.saveFilter(state)
    }
}
