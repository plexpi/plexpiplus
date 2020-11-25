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
                searchBar
                list
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
    }
    
    private var filterView: some View {
        VStack {
            FilterView(state: $model.filterState)
            Spacer()
        }
    }
    
    private var searchBar: some View {
        HStack {
            SearchField(text: $model.searchQuery, isEditing: $isEditingFilters) {
                presenter.loadTorrents()
            }
            
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
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
        .navigationBarHidden(isEditingFilters)
        .onTapGesture {
            self.isEditingFilters = true
        }
    }
    
    private var list: some View {
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
        .navigationBarTitleDisplayMode(.automatic)
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
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
