//
//  PhotoListRawData.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/26/20.
//  Copyright © 2020 박병준. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let photoListRawData = try PhotoListRawData(json)

import Foundation

// MARK: - PhotoListRawDatum
struct PhotoListItemData: Codable {
    let photoListRawDatumDescription, id: String?
    let updatedAt: Date?
    let urls: UrlsInfo?
    let user: UserInfo?
    let width: Int?
    let color: String?
    let height: Int?

    enum CodingKeys: String, CodingKey {
        case photoListRawDatumDescription = "description"
        case id
        case updatedAt = "updated_at"
        case urls, user, width, color, height
    }
}

// MARK: PhotoListRawDatum convenience initializers and mutators

extension PhotoListItemData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PhotoListItemData.self, from: data)
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
        photoListRawDatumDescription: String?? = nil,
        id: String?? = nil,
        updatedAt: Date?? = nil,
        urls: UrlsInfo?? = nil,
        user: UserInfo?? = nil,
        width: Int?? = nil,
        color: String?? = nil,
        height: Int?? = nil
    ) -> PhotoListItemData {
        return PhotoListItemData(
            photoListRawDatumDescription: photoListRawDatumDescription ?? self.photoListRawDatumDescription,
            id: id ?? self.id,
            updatedAt: updatedAt ?? self.updatedAt,
            urls: urls ?? self.urls,
            user: user ?? self.user,
            width: width ?? self.width,
            color: color ?? self.color,
            height: height ?? self.height
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Urls
struct UrlsInfo: Codable {
    let raw, full, thumb, regular: String?
    let small: String?
}

// MARK: Urls convenience initializers and mutators

extension UrlsInfo {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UrlsInfo.self, from: data)
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
        raw: String?? = nil,
        full: String?? = nil,
        thumb: String?? = nil,
        regular: String?? = nil,
        small: String?? = nil
    ) -> UrlsInfo {
        return UrlsInfo(
            raw: raw ?? self.raw,
            full: full ?? self.full,
            thumb: thumb ?? self.thumb,
            regular: regular ?? self.regular,
            small: small ?? self.small
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - User
struct UserInfo: Codable {
    let id, username: String?
}

// MARK: User convenience initializers and mutators

extension UserInfo {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UserInfo.self, from: data)
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
        id: String?? = nil,
        username: String?? = nil
    ) -> UserInfo {
        return UserInfo(
            id: id ?? self.id,
            username: username ?? self.username
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

typealias PhotoListRawData = [PhotoListItemData]

extension Array where Element == PhotoListRawData.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PhotoListRawData.self, from: data)
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

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
