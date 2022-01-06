//
//  MarketAPIService.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/01/05.
//

import Foundation

extension URLSession: URLSessionProtocol {
    
}

class MarketAPIService {
    let session: URLSessionProtocol
    private let successRange = 200..<300
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}

extension MarketAPIService: APIServicable {
    func post(product: PostProduct, images: [Data]) {
        
    }
    
    func patch(productID: Int, product: PatchProduct) {
        
    }
    
    func post(productID: Int, secret: String) {
        
    }
    
    func delete(productID: Int, productSecret: String) {
        
    }
    
    func get(productID: Int, completionHandler: @escaping (Result<Product, APIError>) -> Void) {
        let url = URL(string: "https://market-training.yagom-academy.kr/api/products/\(productID)")
        let request = URLRequest(url: url!)
        
        let dataTask = session.dataTask(with: request) { [unowned self]data, response, error in
            guard error == nil else {
                completionHandler(.failure(APIError.invalidHTTPMethod))
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  self.successRange.contains(statusCode) else {
                completionHandler(.failure(APIError.invalidRequest))
                return
            }
            guard let data = data else {
                completionHandler(.failure(APIError.noData))
                return
            }
            do {
                let product = try parse(with: data, type: Product.self)
                completionHandler(.success(product))
            } catch JSONError.parsingError {
                print(JSONError.parsingError.description)
                completionHandler(.failure(APIError.invalidRequest))
            } catch let error{
                print(error)
            }
        }
        dataTask.resume()
    }
    
    func get(pageNumber: Int, itemsPerPage: Int, completionHandler: @escaping (Result<Page, APIError>) -> Void) {
        let url = URL(string: "https://market-training.yagom-academy.kr/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)")
        let request = URLRequest(url: url!)
        
        let dataTask = session.dataTask(with: request) { [unowned self]data, response, error in
            guard error == nil else {
                completionHandler(.failure(APIError.invalidHTTPMethod))
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  self.successRange.contains(statusCode) else {
                completionHandler(.failure(APIError.invalidRequest))
                return
            }
            guard let data = data else {
                completionHandler(.failure(APIError.noData))
                return
            }
            do {
                let page = try parse(with: data, type: Page.self)
                completionHandler(.success(page))
            } catch JSONError.parsingError {
                print(JSONError.parsingError.description)
                completionHandler(.failure(APIError.invalidRequest))
            } catch let error{
                print(error)
            }
        }
        dataTask.resume()
    }
}

extension MarketAPIService: Parsable {
    
}
