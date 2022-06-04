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
        static let identifierSerialNumber = UserInformation.identifier
        static let contentType = "Content-Type"
    }
    
    static func productList(pageNumber: Int, perPages: Int) -> EndPoint {
        let queryParamters = ProductRequest(
            pageNumber: pageNumber,
            perPages: perPages
        )
        let endpoint = EndPoint(
            path: Constants.basePath,
            queryParameters: queryParamters
        )
        
        return endpoint
    }
    
    static func productPost(_ body: ProductRequest) -> EndPoint {
        let headers: [String: String] = [
            Constants.identifier: Constants.identifierSerialNumber,
            Constants.contentType: "multipart/form-data; boundary=\"\(body.boundary ?? "")\""
        ]
        
        let endpoint = EndPoint(
            path: Constants.basePath,
            method: .post,
            bodyParameters: body,
            headers: headers
        )
        
        return endpoint
    }
    
    static func productDetail(productID: Int) -> EndPoint {
        let endpoint = EndPoint(
            path: Constants.basePath + "/\(productID)"
        )
        
        return endpoint
    }
    
    static func productModify(productID: Int?, body: ProductRequest) -> EndPoint {
        let headers: [String: String] = [
            Constants.identifier: Constants.identifierSerialNumber,
            Constants.contentType: "application/json"
        ]
        
        let endpoint = EndPoint(
            path: Constants.basePath + "/\(productID ?? .zero)",
            method: .patch,
            bodyParameters: body,
            headers: headers
        )
        
        return endpoint
    }
    
    static func productSecret(productID: Int?, body: ProductRequest) -> EndPoint {
        let headers: [String: String] = [
            Constants.identifier: Constants.identifierSerialNumber,
            Constants.contentType: "application/json"
        ]
        
        let endpoint = EndPoint(
            path: Constants.basePath + "/\(productID ?? .zero)" + "/secret",
            method: .post,
            bodyParameters: body,
            headers: headers
        )
        
        return endpoint
    }
    
    static func productDelete(productID: Int?, secret: String) -> EndPoint {
        let headers: [String: String] = [
            Constants.identifier: Constants.identifierSerialNumber
        ]
        
        let endpoint = EndPoint(
            path: Constants.basePath + "/\(productID ?? .zero)" + "/\(secret)",
            method: .delete,
            headers: headers
        )
        
        return endpoint
    }
}
