//
//  OpenMarket - NetworkManager.swift
//  Created by Zhilly, Dragon. 22/11/15
//  Copyright © yagom. All rights reserved.
//

import Foundation

class NetworkManager {
    var semaphore = DispatchSemaphore (value: 0)
    let hostURL: String = "https://openmarket.yagom-academy.kr"
    
    func getApplicationHealthChecker() {
        guard let targetURL: URL = URL(string: hostURL + "/healthChecker") else {
            return
        }
        var request: URLRequest = URLRequest(url: targetURL,timeoutInterval: Double.infinity)
        
        request.httpMethod = "GET"
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                self.semaphore.signal()
                return
            }
            print(String(data: data, encoding: .utf8)!)
            self.semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
    func getItemListCheck(pageNumber: Int, itemPerPage: Int, searchValue: String? = nil) {
        let pageNumberString: String = "page_no=" + String(pageNumber)
        let itemPerPageString: String = "&items_per_page=" + String(itemPerPage)
        var searchValueString: String = ""
        
        if let unwrappingSearchValue: String = searchValue {
            searchValueString = "&search_value=" + unwrappingSearchValue
        }
        
        guard let targetURL: URL = URL(string:
                                        hostURL +
                                       "/api/products?" +
                                       pageNumberString +
                                       itemPerPageString +
                                       searchValueString
        ) else {
            return
        }
        
        var request: URLRequest = URLRequest(url: targetURL,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                self.semaphore.signal()
                return
            }
            print(String(data: data, encoding: .utf8)!)
            self.semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
    func getItemDetailListCheck(productID: Int) {
        let productIDString: String = String(productID)
        guard let targetURL: URL = URL(string: hostURL + "/api/products/" + productIDString) else {
            return
        }
        var request: URLRequest = URLRequest(url: targetURL,timeoutInterval: Double.infinity)
        
        request.httpMethod = "GET"
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                self.semaphore.signal()
                return
            }
            print(String(data: data, encoding: .utf8)!)
            self.semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
}
