//
//  FilterStateView.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 11. 21..
//

import SwiftUI

class FilterStateViewState: ObservableObject {
    static let `default` = FilterStateViewState(type: .tv, language: .en)
    
    @Published var type: TorrentType
    @Published var language: TorrentLanguage
    
    init(type: TorrentType, language: TorrentLanguage) {
        self.type = type
        self.language = language
    }
}

struct FilterStateView: View {
    @Binding var state: FilterStateViewState
    
    var body: some View {
        VStack {
            state.type.image
            state.language.text
        }
    }
}

struct FilterStateView_Previews: PreviewProvider {
    static var previews: some View {
        FilterStateView(state: Binding<FilterStateViewState>.constant(
                            FilterStateViewState.default))
    }
}
