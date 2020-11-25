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
    
    @ObservedObject private var model: TorrentListViewModel
    @ObservedObject private var presenter: TorrentsListPresenter
    
    init(presenter: TorrentsListPresenter) {
        self.model = presenter.viewModel
        self.presenter = presenter
    }
    
    var body: some View {
        NavigationView {
            VStack {
                searchView
                
                ZStack {
                    ProgressView()
                        .opacity(model.isLoading ? 1 : 0)
                    
                    torrentsList
                        .opacity(!(model.isLoading || isEditingFilters) ? 1 : 0)
                        
                    
                    filterView
                        .opacity(isEditingFilters ? 1 : 0)
                        .padding()
                }
                .navigationBarTitle(Text("Torrents"))
                .navigationBarTitleDisplayMode(.large)
            }
            .onAppear {
                presenter.loadFilterState()
                presenter.loadTorrents()
            }
            .actionSheet(isPresented: $isActionSheetShowing){
                downloadActionSheet
            }
            .alert(isPresented: $model.isAlertShowing, content: {
              downloadStartedAlert
            })
        } 
    }
    
    private var downloadActionSheet: ActionSheet {
        ActionSheet(title: Text("\(selectedTorrentDetail!.name)"),
                    message: nil,
                    buttons: [
                        .default(Text("Download"), action: {
                            self.presenter.download(selectedTorrentDetail!)
                        }),
                        .cancel()
                    ])
    }
    
    private var downloadStartedAlert: Alert {
        Alert(title: Text("Downloading started"))
    }
    
    private var torrentsList: some View {
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
        .listStyle(PlainListStyle())
        .resignKeyboardOnDragGesture()
    }
    
    private var filterView: some View {
        VStack {
            FilterView(state: $model.filterState)
            Spacer()
        }
    }
    
    private var searchView: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("search", text: $model.searchQuery, onEditingChanged: { isEditing in
                    self.isEditingFilters = true
                }, onCommit: {
                    presenter.loadTorrents()
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
                    presenter.loadTorrents()
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
    }
}

struct TorrentsList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TorrentsList(presenter: MainModuleResolver.shared.resolveTorrentsListPresenter())
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
