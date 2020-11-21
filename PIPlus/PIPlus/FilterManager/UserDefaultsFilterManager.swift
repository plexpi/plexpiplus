//
//  UserDefaultsFilterManager.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 11. 04..
//

import Foundation

class UserDefaultsFilterManager: FilterManager {
    private let queue = DispatchQueue(label: "UserDefaultsFilterManagerQueue")
    
    private enum Keys {
        static let category = "USERDEFAULTSKEY_CATEGORY"
        static let language = "USERDEFAULTSKEY_LANGUAGE"
    }
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func saveFilter(_ filter: FilterViewState) {
        queue.sync(flags: .barrier) {
            userDefaults.setValue(filter.category.rawValue, forKey: Keys.category)
            userDefaults.setValue(filter.language.rawValue, forKey: Keys.language)
        }
    }
    
    func loadLastFilter() -> FilterViewState {
        queue.sync {
            guard let rawCategory = userDefaults.value(forKey: Keys.category) as? String,
                  let category = FilterViewState.Category(rawValue: rawCategory),
                  let rawLanguage = userDefaults.value(forKey: Keys.language) as? String,
                  let language = FilterViewState.Language(rawValue: rawLanguage) else {
                return FilterViewState.default
            }
            
            return FilterViewState(category: category, language: language)
        }
    }
}
