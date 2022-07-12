//
//  OpenMarketURLSession.swift
//  OpenMarket
//
//  Created by dhoney96 on 2022/07/12.
//

import Foundation

class OpenMarketURLSession {
    let baseURL = "https://market-training.yagom-academy.kr/"
    
    func loadData(request: URLRequest, completion: @escaping (Data?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error: HTTP request failed")
                return
            }
            
            guard let safeData = data else { return }
            completion(safeData)
        }
        task.resume()
    }
    
    func getMethod(pageNumber: Int? = nil, itemsPerPage: Int? = nil, productId: Int? = nil, completion: @escaping (Data?) -> Void) {
        var safeURL: URL
        
        if productId == nil {
            guard let pageNumber = pageNumber,
                  let itemsPerPage = itemsPerPage,
                  let url = URL(string: baseURL + "api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)") else { return }
            
            safeURL = url
        } else {
            guard let productId = productId,
                  let url = URL(string: baseURL + "api/products/\(productId)") else { return }
            
            safeURL = url
        }
        
        var request = URLRequest(url: safeURL)
        request.httpMethod = RequestType.get.method
        
        loadData(request: request, completion: completion)
    }
}
