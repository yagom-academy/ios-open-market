//
//  NetworkMananger.swift
//  OpenMarket
//
//  Created by Aaron, Jpush on 2022/11/14.
//

import Foundation

struct NetworkManager {
    let host = "https://openmarket.yagom-academy.kr"
    
    enum requestType {
        case healthChecker
        case searchProductList(Int, Int)
        case searchProductDetail(Int)
    }
    
    private func generateURL(type: requestType) -> URL? {
        switch type {
        case .healthChecker:
            return URL(string: String(format: "%@/healthChecker", host))
        case .searchProductList(let pageNo, let itemsPerPage):
            return URL(string:String(format: "%@/api/products?page_no=%d&items_per_page=%d", host, pageNo, itemsPerPage))
        case .searchProductDetail(let productNumber):
            return URL(string: String(format: "%@/api/products/%d", host, productNumber))
        }
    }
    
    //    func fetch(type: requestType) -> ProductsList? {
    //        guard let url = generateURL(type: type) else {
    //            return nil
    //        }
    //
    //        let config = URLSessionConfiguration.default
    //        let session = URLSession(configuration: config)
    //
    //        var result: ProductsList?
    //        print(url)
    //        let dataTask = session.dataTask(with: URLRequest(url: url)) { data, response, error in
    //            let successRange = 200..<300
    //            print("1")
    //
    //            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
    //                return
    //            }
    //            print("2")
    //
    //
    //            guard let resultData = data else {
    //                return
    //            }
    //            print("3")
    //
    //
    //            let decoder = JSONDecoder()
    //            result = try! decoder.decode(ProductsList.self, from: resultData)
    //            print("4")
    //        }
    //
    //        dataTask.resume()
    //
    //
    //        return result
    //    }
    
    func fetch(type: requestType) {
        guard let url = generateURL(type: type) else {
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        print(url)
        let dataTask = session.dataTask(with: URLRequest(url: url)) { data, response, error in
            let successRange = 200..<300
            
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
                return
            }
            print(statusCode)
            
            guard let resultData = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let result = try decoder.decode(ProductsList.self, from: resultData)
                let pages = result.pages
                
                for page in pages {
                    print("page: \(page.description)")
                }
            } catch let error {
                print("--> error: \(error.localizedDescription)")
            }
        }
        
        dataTask.resume()
    }
}
