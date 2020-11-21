//
//  FilterViewPresenter.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 10. 27..
//

import Foundation

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
