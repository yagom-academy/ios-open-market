//
//  APIServicable.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/04.
//

import Foundation

protocol APIServicable {
    func post(product: PostProduct, images: [Data])
    func patch(productID: Int, product: PatchProduct)
    func post(productID: Int, secret: String)
    func delete(productID: Int, productSecret: String)
    func get(productID: Int)
    func get(pageNumber: Int, itemsPerPage: Int)
    func parse<T: Decodable>(with data: Data) -> T?
}

extension APIServicable {
    func parse<T: Decodable>(with data: Data) -> T? {
        do {
            let data = try JSONDecoder().decode(T.self, from: data)
            return data
        } catch {
            return nil
        }
    }
}
