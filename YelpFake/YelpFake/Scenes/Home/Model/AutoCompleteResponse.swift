//
//  AutoCompleteResponse.swift
//  YelpFake
//
//  Created by Luan Almeida on 2025-04-05.
//

struct AutoCompleteResponse: Decodable {
    let terms: [AutoCompleteTerm]
    let categories: [AutoCompleteCategory]
}

struct AutoCompleteCategory: Decodable {
    let title: String
}

struct AutoCompleteTerm: Decodable {
    let text: String
}
