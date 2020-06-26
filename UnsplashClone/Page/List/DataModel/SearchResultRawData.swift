//
//  SearchResultRawData.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/27/20.
//  Copyright © 2020 박병준. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchResultRawData = try SearchResultRawData(json)

import Foundation

// MARK: - SearchResultRawData
struct SearchResultRawData: Codable {
    let results: [PhotoListItemData]?
    let totalPages, total: Int?

    enum CodingKeys: String, CodingKey {
        case results
        case totalPages = "total_pages"
        case total
    }
}

// MARK: SearchResultRawData convenience initializers and mutators

extension SearchResultRawData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SearchResultRawData.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        results: [PhotoListItemData]?? = nil,
        totalPages: Int?? = nil,
        total: Int?? = nil
    ) -> SearchResultRawData {
        return SearchResultRawData(
            results: results ?? self.results,
            totalPages: totalPages ?? self.totalPages,
            total: total ?? self.total
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

