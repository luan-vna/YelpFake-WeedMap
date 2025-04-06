//
//  EnvironmentEnum.swift
//  YelpFake
//
//  Created by Luan Almeida on 2025-04-05.
//

import Foundation

enum EnvironmentEnum {
    case production
}

enum EnvironmentValue: String {
    case baseURL = "BASE_URL"
    case apiKey = "API_KEY"
}

class EnvironmentManager {
    
    private var environment: EnvironmentEnum = .production
    
    public static let shared = EnvironmentManager()
    
    fileprivate init() {}
    
    func load(environment: EnvironmentEnum) {
        self.environment = environment
    }
    
    func value(forKey: EnvironmentValue) -> String? {
        Bundle.main.object(forInfoDictionaryKey: forKey.rawValue) as? String
    }
}
