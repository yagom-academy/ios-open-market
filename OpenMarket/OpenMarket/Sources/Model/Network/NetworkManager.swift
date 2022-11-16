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
    
    func getItemList(pageNumber: Int, itemPerPage: Int, searchValue: String? = nil) {
        var searchValueString: String = String()
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
    
    func getItemDetailList(productID: Int) {
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
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if let serverResponse = response as? HTTPURLResponse {
                switch serverResponse.statusCode {
                case 100...101:
                    print("informational")
                case 200...206:
                    print("success")
                case 300...307:
                    print("redirection")
                case 400...415:
                    print("client error")
                    return
                case 500...505:
                    print("server error")
                    return
                default:
                    print("unknown error")
                    return
                }
            }

            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
    }
}
