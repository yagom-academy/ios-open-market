//
//  SessionManager.swift
//  OpenMarket
//
//  Created by 천수현 on 2021/05/13.
//

import Foundation

enum HTTPMethod {
    static let get: String = "GET"
    static let post: String = "POST"
    static let patch: String = "PATCH"
    static let delete: String = "DELETE"
}

enum BaseURL {
    static let page = "https://camp-open-market-2.herokuapp.com/items/"
    static let item = "https://camp-open-market-2.herokuapp.com/item/"
}

class SessionManager {
    static let shared = SessionManager()
    private let boundary: String = "Boundary-\(UUID().uuidString)"

    private init() {}

    func get<DecodedType: Decodable>(id: Int,
                                     completionHandler: @escaping (Result<DecodedType, Error>) -> Void) {

    }

    func postItem(_ postingItem: PostingItem, completionHandler: @escaping (Result<ResponsedItem, Error>) -> Void) {

    }

    func patchItem(id: Int, patchingItem: PatchingItem,
                   completionHandler: @escaping (Result<ResponsedPage, Error>) -> Void) {

    }

    func deleteItem(id: Int, password: String, completionHandler: @escaping () -> Void) {

    }

    private func body(from formData: FormData) -> Data {
        return Data()
    }

    private func converFileField(key: String, source: String, mimeType: String, value: Data) -> Data {
        return Data()
    }

    private func convertTextField(key: String, value: String) -> String {
        return ""
    }

    enum Error: Swift.Error {
        case invalidURL
        case dataIsNotJSON
    }
}
