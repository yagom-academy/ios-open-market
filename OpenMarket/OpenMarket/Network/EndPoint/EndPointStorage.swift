//
//  EndPoints.swift
//  OpenMarket
//
//  Created by Red, Mino on 2022/05/10.
//

struct EndPointStorage {
    private enum Constants {
        static let basePath = "api/products"
        static let identifier = "identifier"
        static let identifierSerialNumber = "cd706a3e-66db-11ec-9626-796401f2341a"
        static let contentType = "Content-Type"
    }
    
    static func productsList(pageNumber: Int, perPages: Int)
        -> EndPoint {
        let productsRequest = ProductsReceive(
            pageNumber: pageNumber,
            perPages: perPages
        )
        let endpoint = EndPoint(
            path: Constants.basePath,
            queryParameters: productsRequest
        )
        
        return endpoint
    }
    
    static func productsPost(_ productsPost: ProductsPost) -> EndPoint {
        let headers: [String: String] = [
            Constants.identifier: Constants.identifierSerialNumber,
            Constants.contentType: "multipart/form-data; boundary=\"\(productsPost.boundary)\""
        ]
        
        let endpoint = EndPoint(
            path: Constants.basePath,
            method: .post,
            bodyParameters: productsPost,
            headers: headers
        )
        
        return endpoint
    }
}
