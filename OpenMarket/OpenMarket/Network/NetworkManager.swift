//  NetworkManager.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/15.

import Foundation

enum NetworkError: Error {
    case statusCodeError
    case noData
}


class NetworkManager {
    let session: URLSession
    let baseUrl: String = "https://openmarket.yagom-academy.kr"
    
    init(session: URLSession) {
        self.session = session
    }
    
    func dataTask(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let task = session.dataTask(with: request) { data, urlResponse, error in
            
            guard let httpResponse = urlResponse as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                      return completion(.failure(.statusCodeError))
                  }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            return completion(.success(data))
        }
        
        task.resume()
    }
    
    // URL Request에 들어갈 URL을 생성해줘야 하는데
    // healthChecker -> 패스 필요
    func checkAPIHealth() {
        guard let url = URL(string: baseUrl + "/healthChecker") else { return }
        let request = URLRequest(url: url)
        
        dataTask(request: request, completion: { result in
            switch result {
            case .success(_):
                print("OK")
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    // products?page_no=&items_per_page= -> 패스+쿼리가 필요!
    // 쿼리에 필요한 정보: 페이지번호, 아이템퍼페이지
    func fetchProductList(pageNumber: Int, itemsPerPage: Int) {
        guard let url = URL(string: baseUrl + "/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)") else { return }
        
        let request = URLRequest(url: url)
        
        dataTask(request: request, completion: { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let productList = try decoder.decode(ProductList.self, from: data)
                    print(productList.lastIndex)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    // products/id -> 패스 + id값 필요
    func fetchProductDetail(for id: Int) {
        guard let url = URL(string: baseUrl + "/api/products/\(id)") else { return }
        
        let request = URLRequest(url: url)
        
        dataTask(request: request, completion: { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let product = try decoder.decode(Product.self, from: data)
                    print(product.name)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}
