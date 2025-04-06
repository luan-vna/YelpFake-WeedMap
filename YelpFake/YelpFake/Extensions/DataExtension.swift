//
//  DataExtension.swift
//  YelpFake
//
//  Created by Luan Almeida on 2025-04-05.
//

import Foundation

extension Data {
    func decode<T: Decodable>(as type: T.Type) throws -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? decoder.decode(T.self, from: self)
    }
}
