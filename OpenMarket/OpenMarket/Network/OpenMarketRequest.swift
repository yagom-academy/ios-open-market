//
//  OpenMarketRequest.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/18.
//

import Foundation

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
}
