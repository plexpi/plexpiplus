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
    
    func saveFilter(_ filter: TorrentFilter) {
        queue.sync(flags: .barrier) {
            userDefaults.setValue(filter.type.rawValue, forKey: Keys.category)
            userDefaults.setValue(filter.language.rawValue, forKey: Keys.language)
        }
    }
    
    func loadLastFilter() -> TorrentFilter {
        queue.sync {
            guard let rawType = userDefaults.value(forKey: Keys.category) as? String,
                  let type = TorrentType(rawValue: rawType),
                  let rawLanguage = userDefaults.value(forKey: Keys.language) as? String,
                  let language = TorrentLanguage(rawValue: rawLanguage) else {
                return TorrentFilter.default
            }
            
            return TorrentFilter(type: type, language: language)
        }
    }
}
