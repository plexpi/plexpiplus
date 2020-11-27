//
//  TorrentRow.swift
//  PIPlus
//
//  Created by Adam Borbas on 2020. 11. 21..
//

import SwiftUI

struct TorrentDetail: Identifiable {
    var   id: String {
        return name
    }
    let name: String
    let date: String
    let size: String
    let downloadURL: String
}

struct TorrentRow: View {
    let torrent: TorrentDetail
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(torrent.name)
                .foregroundColor(.primary)
                .truncationMode(.tail)
                .lineLimit(1)
            
            HStack {
                Text(torrent.date)
                    .truncationMode(.tail)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Text(torrent.size)
                    .font(.subheadline).font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct TorrentRow_Previews: PreviewProvider {
    static var previews: some View {
        TorrentRow(torrent: TorrentDetail(name: "Game of Thrones", date: "2020.11.07", size: "12.3 GB", downloadURL: "http://torrent.com/torrent"))
    }
}
