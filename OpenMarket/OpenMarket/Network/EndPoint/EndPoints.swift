//
//  EndPoints.swift
//  OpenMarket
//
//  Created by Red, Mino on 2022/05/10.
//

import Foundation

struct EndPoints {
    static func getProductsList(pageNumber: Int, perPages: Int) -> EndPoint {
        let productsListDTO = ProductsListDTO(pageNumber: pageNumber, perPages: perPages)
        let endpoint = EndPoint(path: "/api/products", queryParameters: productsListDTO)
        return endpoint
    }
    static func getProductsDetail(id: String) -> EndPoint {
        let endpoint = EndPoint(path: "/api/products/\(id)")
        return endpoint
    }
}
