//
//  BusinessService.swift
//  YelpFake
//
//  Created by Luan Almeida on 2025-04-05.
//

import Combine
import Foundation

protocol AutoCompleteServiceProtocol {
    func autocomplete(text: String) async throws -> AutoCompleteResponse?
}

class AutoCompleteService: AutoCompleteServiceProtocol {
    
    enum Constants { }
  
    private let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
    }
    
    func autocomplete(text: String) async throws -> AutoCompleteResponse? {
        let items = [
            URLQueryItem(name: "text", value: text)
        ]
        let response: AutoCompleteResponse? = try await requestManager.get(path: Constants.autocomplete,
                                                                           queryItems: items)
        return response
    }
}

extension AutoCompleteService.Constants {
    static let autocomplete = "/v3/autocomplete"
}
