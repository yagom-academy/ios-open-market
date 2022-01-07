//
//  MockParser.swift
//  OpenMarketTests
//
//  Created by 이호영 on 2022/01/05.
//

import Foundation
@testable import OpenMarket

struct StubParser: JSONParserable {
    func decode<T>(source: Data, decodingType: T.Type) -> Result<T, ParserError> where T : Decodable {
        if decodingType == Products.self {
            let products = Products(pageNumber: 1, itemsPerPage: 1, totalCount: 1, offset: 1, limit: 1, pages: [], lastPage: 1, hasNext: true, hasPrev: true)
            return .success(products as! T)
        } else if decodingType == Product.self {
            let product = Product(id: 1, vendorID: 1, name: "", thumbnail: "", currency: .krw, price: 1, bargainPrice: 1, discountedPrice: 1, stock: 1, createdAt: "", issuedAt: "", images: nil, vendors: nil)
            return .success(product as! T)
        } else {
            return .failure(ParserError.decodingFail)
        }
    }
    
    func encode<T>(object: T) -> Result<Data, ParserError> where T : Encodable {
        return .success(Data())
    }
}
