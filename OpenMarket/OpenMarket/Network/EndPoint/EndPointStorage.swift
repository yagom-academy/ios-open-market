//
//  EndPoints.swift
//  OpenMarket
//
//  Created by Red, Mino on 2022/05/10.
//

fileprivate extension Constants {
    static let productsListPath = "/api/products"
    static let productsDetailPath = "/api/products/"
}

struct EndPointStorage {
    static func productsList(pageNumber: Int, perPages: Int)
        -> EndPoint {
        let productsListDTO = ProductsListDTO(
            pageNumber: pageNumber,
            perPages: perPages)
        let endpoint = EndPoint(
            path: Constants.productsListPath,
            queryParameters: productsListDTO)
        return endpoint
    }
    static func productsDetail(id: String) -> EndPoint {
        let endpoint = EndPoint(path: Constants.productsDetailPath + id)
        return endpoint
    }
}
