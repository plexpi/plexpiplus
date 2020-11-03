//
//  CustomTorrentSearch.swift
//  TorrentSearch
//
//  Created by Adam Borbas on 2020. 10. 25..
//

import Foundation
import Alamofire

public class CustomTorrentSearch: TorrentSearch {
    private let baseURL = URL(string: "http://raspberrypi.local:5000")!
    
    public init() {
        
    }
    
    public func series(_ params: TorrentSearchParams, _ completionHandler: @escaping (Result<[Torrent], Error>) -> ()) {
        let request = AF.request(baseURL.appendingPathComponent("torrents/series/search"),
                   parameters: params.urlParameters(),
                   encoder: URLEncodedFormParameterEncoder.default)
        request.validate()
            .responseDecodable(of: [Torrent].self) { response in
                guard let torrents = response.value else {
                    completionHandler(.failure(response.error!))
                    return
                }
                
                completionHandler(.success(torrents))
            }
    }
    
    public func movies(_ params: TorrentSearchParams, _ completionHandler: @escaping (Result<[Torrent], Error>) -> ()) {
        AF.request(baseURL.appendingPathComponent("torrents/movies/search"),
                   parameters: params.urlParameters(),
                   encoder: URLEncodedFormParameterEncoder.default)
            .validate()
            .responseDecodable(of: [Torrent].self) { response in
                guard let torrents = response.value else {
                    completionHandler(.failure(response.error!))
                    return
                }
                
                completionHandler(.success(torrents))
            }
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
