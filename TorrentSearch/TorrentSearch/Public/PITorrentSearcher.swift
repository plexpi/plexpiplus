//
//  PITorrentSearcher.swift
//  TorrentSearch
//
//  Created by Adam Borbas on 2020. 10. 25..
//

import Foundation
import Alamofire
import Combine

public class PITorrentSearcher: TorrentSearcher {
    private let baseURL: URL
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    public func series(_ params: TorrentSearchParams) -> AnyPublisher<[Torrent], Error> {
        return AF.request(baseURL.appendingPathComponent("torrents/series/search"),
                       parameters: params.urlParameters(),
                       encoder: URLEncodedFormParameterEncoder.default)
            .publishDecodable(type: [Torrent].self)
            .tryMap { response in
                guard let torrents = response.value else {
                    throw response.error!
                }

                return torrents
            }
            .eraseToAnyPublisher()
    }
    
    public func movies(_ params: TorrentSearchParams) -> AnyPublisher<[Torrent], Error> {
        return AF.request(baseURL.appendingPathComponent("torrents/movies/search"),
                          parameters: params.urlParameters(),
                          encoder: URLEncodedFormParameterEncoder.default)
            .publishDecodable(type: [Torrent].self)
            .tryMap { response in
                guard let torrents = response.value else {
                    throw response.error!
                }
                
                return torrents
            }
            .eraseToAnyPublisher()
    }
    
    
}

extension TorrentSearchParams {
    func urlParameters() -> [String: String] {
        return [
            "category": self.category.rawValue,
            "q": self.query
        ]
    }
}
