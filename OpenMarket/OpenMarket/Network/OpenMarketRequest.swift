//
//  OpenMarketRequest.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/18.
//

import UIKit

struct OpenMarketRequest {
    private let address = NetworkNamespace.url.name
    
    func createQuery(of pageNo: String = String(Metric.firstPage), with itemsPerPage: String = String(Metric.itemCount)) -> [URLQueryItem] {
        let pageNo = URLQueryItem(name: ModelNameSpace.pageNo.name, value: pageNo)
        let itemsPerPage = URLQueryItem(name: ModelNameSpace.itemsPerPage.name, value: itemsPerPage)
        return [pageNo, itemsPerPage]
    }
    
    func requestProductList(queryItems: [URLQueryItem]) -> URLRequest? {
        var components = URLComponents(string: address)
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    func requestProductDetail(of productId: String) -> URLRequest? {
        let components = URLComponents(string: address)
        
        guard var url = components?.url else {
            return nil
        }
        
        url.appendPathComponent(productId)
        return URLRequest(url: url)
    }
    
    func createPostJson(params: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
    }
    
    func creatPostImage(named: String) -> Data? {
        let image = UIImage(named: named)
        
        guard let imageData = image?.jpegData(compressionQuality: 1.0) else { return nil }
        return imageData
    }
    
    func creatPostRequest(identifier: String) -> URLRequest? {
        guard let url = URL(string: NetworkNamespace.url.name) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = NetworkNamespace.post.name

        request.addValue(Multipart.boundaryForm + "\"\(Multipart.boundaryValue)\"", forHTTPHeaderField: Multipart.contentType)
        request.addValue(identifier, forHTTPHeaderField: Request.identifier)
        return request
    }
}
