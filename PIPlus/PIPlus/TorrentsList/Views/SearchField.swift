//
//  SearchField.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 11. 25..
//

import SwiftUI

struct SearchField: View {
    @Binding var text: String
    @Binding var isEditing: Bool
    private let onCommit: () -> Void
    
    init(text: Binding<String>, isEditing: Binding<Bool>, onCommit: @escaping () -> Void = {}) {
        self._text = text
        self._isEditing = isEditing
        self.onCommit = onCommit
    }
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            
            TextField("search",
                      text: $text,
                      onEditingChanged: { isEditing in
                        self.isEditing = true
                      },
                      onCommit: self.onCommit
            )
            .foregroundColor(.primary)
            
            Button(action: {
                text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .opacity(!text.isEmpty && isEditing ? 1 : 0)
            }
        }
        .padding(EdgeInsets(top: 9, leading: 6, bottom: 9, trailing: 6))
        .foregroundColor(.secondary)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10.0)
    }
}

struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        SearchField(text: Binding.constant(""), isEditing: Binding.constant(false))
    }
}
