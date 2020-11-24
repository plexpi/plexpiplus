//
//  TorrentsList.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 11. 21..
//

import SwiftUI
import TorrentSearch
import TorrentDownloader

struct TorrentsList: View {
    @State private var isEditingFilters = false
    @State private var selectedTorrentDetail: TorrentDetail?
    @State private var isActionSheetShowing = false
    @ObservedObject private var model = TorrentListViewModel(
        torrentSearcher: PITorrentSearcher(baseURL: URL(string: "http://raspberrypi.local:5000")!),
        torrentDownloader: PITorrentDownloader(baseURL: URL(string: "http://raspberrypi.local:45780")!),
        filterManager: UserDefaultsFilterManager()
    )
    
    var body: some View {
        NavigationView {
            VStack {
                // Search view
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        
                        TextField("search", text: $model.searchQuery, onEditingChanged: { isEditing in
                            self.isEditingFilters = true
                        }, onCommit: {
                            model.loadTorrents()
                        }).foregroundColor(.primary)
                        
                        Button(action: {
                            model.searchQuery = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .opacity(!model.searchQuery.isEmpty && isEditingFilters ? 1 : 0)
                        }
                    }
                    .padding(EdgeInsets(top: 9, leading: 6, bottom: 9, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)
                    
                    ZStack {
                        Button("Done") {
                            UIApplication.shared.endEditing(true)
                            self.isEditingFilters = false
                            model.loadTorrents()
                        }
                        .foregroundColor(Color(.systemBlue))
                        .opacity(isEditingFilters ? 1 : 0)
                        
                        FilterStateView(state: $model.filterState)
                            .opacity(isEditingFilters ? 0 : 1)
                    }
                }
                .padding(.horizontal)
                .navigationBarHidden(isEditingFilters)
                .onTapGesture {
                    self.isEditingFilters = true
                }
                
                ZStack {
                    ProgressView()
                        .opacity(model.isLoading ? 1 : 0)
                    
                    List {
                        ForEach(model.torrents) { torrent in
                            Button(action: {
                                selectedTorrentDetail = torrent
                                isActionSheetShowing = true
                            }) {
                                TorrentRow(torrent: torrent)
                            }
                        }
                    }
                    .opacity(model.isLoading || isEditingFilters ? 0 : 1)
                    .listStyle(PlainListStyle())
                    .resignKeyboardOnDragGesture()
                    
                    VStack {
                        FilterView(state: $model.filterState)
                        Spacer()
                    }
                    .padding()
                    .opacity(isEditingFilters ? 1 : 0)
                }
                .navigationBarTitle(Text("Torrents"))
                .navigationBarTitleDisplayMode(.large)
            }
            .onAppear {
                model.loadTorrents()
            }
            .actionSheet(isPresented: $isActionSheetShowing){
                ActionSheet(title: Text("\(selectedTorrentDetail!.name)"),
                            message: nil,
                            buttons: [
                                .default(Text("Download"), action: {
                                    self.model.download(selectedTorrentDetail!)
                                }),
                                .cancel()
                            ])
            }
            .alert(isPresented: $model.isAlertShowing, content: {
                Alert(title: Text("Downloading started"))
            })
        } 
    }
}

struct TorrentsList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TorrentsList()
        }
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
