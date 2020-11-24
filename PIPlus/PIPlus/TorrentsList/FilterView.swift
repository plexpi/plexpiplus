//
//  FilterView.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 11. 23..
//

import SwiftUI

enum TorrentType: String, Identifiable {
    case film = "film"
    case tv = "tv"
    
    var image: Image {
        return Image(systemName: rawValue)
    }
    
    var id: String { rawValue }
}

enum TorrentLanguage: String, Identifiable {
    case en = "en"
    case hu = "hu"
    
    var text: Text {
        return Text(rawValue)
    }
    
    var id: String { rawValue }
}

struct FilterView: View {
    private let types: [TorrentType] = [.tv, .film]
    private let languages: [TorrentLanguage] = [.en, .hu]
    
    @Binding var state: FilterStateViewState
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Type")
            Picker("type", selection: $state.type) {
                ForEach(types) { type in
                    type.image.tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Text("Language")
            Picker("language", selection: $state.language) {
                ForEach(languages) { language in
                    language.text.tag(language)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
    }
}


struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(state: Binding<FilterStateViewState>.constant(FilterStateViewState.default))
    }
}
