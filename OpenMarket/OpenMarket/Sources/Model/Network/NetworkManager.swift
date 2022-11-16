//
//  OpenMarket - NetworkManager.swift
//  Created by Zhilly, Dragon. 22/11/15
//  Copyright © yagom. All rights reserved.
//

import Foundation

struct NetworkManager {
    let hostUrlAddress: String = ProductsAPIEnum.hostUrl.address
    
    func getApplicationHealthChecker() {
        let targetAddress: String = hostUrlAddress + ProductsAPIEnum.healthChecker.address
        guard let targetURL: URL = URL(string: targetAddress) else {
            return
        }
        let targetRequest = makeRequest(url: targetURL, httpMethod: HttpMethodEnum.get)
        
        dataTask(request: targetRequest)
    }
    
    func getItemListCheck(pageNumber: Int, itemPerPage: Int, searchValue: String? = nil) {
        var searchValueString: String = ""
        if let unwrappingSearchValue: String = searchValue {
            searchValueString = ProductsAPIEnum.bridge.address + ProductsAPIEnum.searchValue.address + unwrappingSearchValue
        }
        let targetAddress: String = hostUrlAddress +
        ProductsAPIEnum.products.address +
        ProductsAPIEnum.pageNumber.address + String(pageNumber) +
        ProductsAPIEnum.bridge.address +
        ProductsAPIEnum.itemPerPage.address + String(itemPerPage) +
        searchValueString
        guard let targetURL: URL = URL(string: targetAddress) else {
            return
        }
        let targetRequest = makeRequest(url: targetURL, httpMethod: HttpMethodEnum.get)
        
        dataTask(request: targetRequest)
    }
    
    func getItemDetailListCheck(productID: Int) {
        let targetAddress: String = hostUrlAddress + ProductsAPIEnum.products.address + String(productID)
        guard let targetURL: URL = URL(string: targetAddress) else {
            return
        }
        let targetRequest = makeRequest(url: targetURL, httpMethod: HttpMethodEnum.get)
        
        dataTask(request: targetRequest)
    }
    
    private func makeRequest(url: URL, httpMethod: HttpMethodEnum) -> URLRequest {
        var request: URLRequest = URLRequest(url: url,timeoutInterval: Double.infinity)
        
        request.httpMethod = httpMethod.name
        
        return request
    }
    
    private func dataTask(request: URLRequest) {
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
    }
}
