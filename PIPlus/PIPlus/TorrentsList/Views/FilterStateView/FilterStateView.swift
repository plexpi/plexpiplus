//
//  FilterStateView.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 11. 21..
//

import SwiftUI

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
                            FilterStateViewState(filter: TorrentFilter.default)))
    }
}
