//
//  BusinessService.swift
//  YelpFake
//
//  Created by Luan Almeida on 2025-04-05.
//

import Combine
import Foundation

protocol BusinessServiceProtocol {
    func search(term: String, page: Int) async throws -> BusinessResponse?
}

class BusinessService: BusinessServiceProtocol {
    
    enum Constants { }
    
    private let longitude: Double = -119.417931
    private let latitude: Double = 36.778259
    
    private let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
    }
    
    func search(term: String, page: Int = 1) async throws -> BusinessResponse? {
        let items = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "offset", value: String(page)),
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude))
        ]
        let response: BusinessResponse? = try await requestManager.get(path: Constants.search,
                                                                       queryItems: items)
        return response
    }
}

extension BusinessService.Constants {
    static let search = "/v3/businesses/search"
}
