//
//  RequestManager.swift
//  YelpFake
//
//  Created by Luan Almeida on 2025-04-05.
//

import Foundation

protocol RequestManagerProtocol {
    func get<T: Decodable>(path: String, queryItems: [URLQueryItem]) async throws -> T?
}

class RequestManager: RequestManagerProtocol {
    
    func get<T: Decodable>(path: String, queryItems: [URLQueryItem] = []) async throws -> T? {
        let request = try requestFor(path: path, queryItems: queryItems)
        let (data, _) = try await URLSession.shared.data(for: request)
        guard let result = try data.decode(as: T.self) else {
            throw RequestError.parseError
        }
        return result
    }
}

extension RequestManager {
    
    func requestFor(path: String, queryItems: [URLQueryItem]) throws -> URLRequest {
        guard let url = urlFor(path: path, queryItems: queryItems) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(EnvironmentManager.shared.value(forKey: .apiKey),
                         forHTTPHeaderField: "Authorization")
        return request
    }

    private func urlFor(path: String, queryItems: [URLQueryItem] = []) -> URL? {
        let environment = EnvironmentManager.shared
        var components = URLComponents()
        components.scheme = "https"
        components.host = environment.value(forKey: .baseURL)
        components.queryItems = queryItems
        components.path = path
        return components.url
    }
}

enum RequestError: Error {
    case parseError
}

extension RequestError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .parseError:
            return NSLocalizedString("No parsing data.", comment: "")
        }
    }
}
