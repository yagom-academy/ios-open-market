//
//  Features.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/10.
//

import Foundation


final class RequestAssistant {
    let sessionManager = URLSessionProvider(session: URLSession.shared)
    
    func requestListApi(pageNum: Int, items_per_page: Int, completionHandler: @escaping ((Result<ProductList, Error>) -> Void)) {
        let path = "api/products"
        let queryString = "?page_no=\(pageNum)&items_per_page=\(items_per_page)"
        
        sessionManager.sendGet(path: path + queryString, completionHandler: { data, response, error in
            guard let data = data else {
                return
            }
            guard let result = try? JSONDecoder().decode(ProductList.self, from: data) else { return }
            completionHandler(.success(result))
        })
    }
    
    func requestDetailApi(product_id: Int, completionHandler: @escaping ((Result<Product, Error>) -> Void)) {
        let path = "api/products/\(product_id)"
        
        sessionManager.sendGet(path: path, completionHandler: { data, response, error in
            guard let data = data else {
                return
            }
            guard let result = try? JSONDecoder().decode(Product.self, from: data) else { return }
            completionHandler(.success(result))
        })
    }
    
    func requestHealthCheckerApi(completionHandler: @escaping ((Result<String, Error>) -> Void)) {
        let path = "healthChecker"
        sessionManager.sendGet(path: path, completionHandler: { data, response, error in
            guard let data = data else {
                return
            }
            if let result = String(data: data, encoding: .utf8) {
                completionHandler(.success(result))
            }
        })
    }
    
    
}
