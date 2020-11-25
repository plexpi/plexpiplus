//
//  PITorrentDownloader.swift
//  TorrentDownloader
//
//  Created by Adam Borbas on 2020. 11. 25..
//

import Foundation
import Alamofire
import Combine

public class PITorrentDownloader: TorrentDownloader {
    private let baseURL: URL
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    public func downloadTorrent(params: DownloadTorrentParams) -> AnyPublisher<String, Error> {
        return AF.request(baseURL.appendingPathComponent("download"),
                          method: .post,
                          parameters: params,
                          encoder: JSONParameterEncoder.default)
            .validate()
            .publishDecodable(type: String.self)
            .tryMap { response in
                guard let result = response.value else {
                    throw response.error!
                }
                
                return result
            }
            .eraseToAnyPublisher()
    }
}
