//
//  TorrentDownloader.swift
//  TorrentDownloader
//
//  Created by Adam Borbas on 2020. 10. 27..
//

import Foundation
import Alamofire

public struct DownloadTorrentParams: Encodable {
    public let category: String
    public let url: String
    
    public init(category: String, url: String) {
        self.category = category
        self.url = url
    }
}

public protocol TorrentDownloader {
    func downloadTorrent(params: DownloadTorrentParams, _ completionHandler: @escaping (Result<String, Error>) -> ())
}

public class PITorrentDownloader: TorrentDownloader {
    private let baseURL: URL
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    public func downloadTorrent(params: DownloadTorrentParams, _ completionHandler: @escaping (Result<String, Error>) -> ()) {
        AF.request(baseURL.appendingPathComponent("download"),
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default)
            .validate()
            .responseString { response in
                switch response.result {
                case .success(let result):
                    completionHandler(.success(result))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
    }
}
