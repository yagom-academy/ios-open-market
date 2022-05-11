//
//  EndPoints.swift
//  OpenMarket
//
//  Created by Red, Mino on 2022/05/10.
//

fileprivate extension Constansts {
    static let productsListPath = "/api/products"
    static let productsDetailPath = "/api/products/"
}

struct EndPoints {
    static func getProductsList(pageNumber: Int, perPages: Int) -> EndPoint {
        let productsListDTO = ProductsListDTO(pageNumber: pageNumber, perPages: perPages)
        let endpoint = EndPoint(path: Constansts.productsListPath, queryParameters: productsListDTO)
        return endpoint
    }
    static func getProductsDetail(id: String) -> EndPoint {
        let endpoint = EndPoint(path: Constansts.productsDetailPath + id)
        return endpoint
    }
}
