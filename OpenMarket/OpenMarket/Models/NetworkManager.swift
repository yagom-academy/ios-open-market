//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 스톤, 로빈 on 2022/11/15.
//

import Foundation

struct NetworkManager {
    let url: String
    var session: URLSessionProtocol
    
    init(url: String = "https://openmarket.yagom-academy.kr/", session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.url = url
        self.session = session
    }
    
    func checkAPIHealth(completion: @escaping (Bool) -> Void) {
        let urlString = "\(url)healthChecker"
        
        guard let url: URL = URL(string: urlString) else { return }
        
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil { return completion(false) }
            guard let httpResponse = response as? HTTPURLResponse else { return completion(false) }
            
            return completion(httpResponse.statusCode == 200)
        }
        
        dataTask.resume()
        
    }
    
    func fetchItemList(pageNo: Int, pageCount: Int, completion: @escaping (Result<ItemList, NetworkError>) -> Void) {
        let urlString = "\(url)api/products?page_no=\(pageNo)&items_per_page=\(pageCount)"
        
        guard let url: URL = URL(string: urlString) else { return }
        
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                return completion(.failure(.invalidError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                return completion(.failure(.responseError))
            }
            
            guard let data = data else { return completion(.failure(.dataError))}
            
            do {
                let itemList: ItemList = try JSONDecoder().decode(ItemList.self, from: data)
                completion(.success(itemList))
            } catch {
                completion(.failure(.parseError))
            }
        }
        
        dataTask.resume()
    }
    
    func fetchItem(productId: Int, completion: @escaping (Result<Item, NetworkError>) -> ()) {
        let urlString = "\(url)api/products/\(productId)"
        
        guard let url: URL = URL(string: urlString) else { return }
        
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                return completion(.failure(.invalidError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                return completion(.failure(.responseError))
            }
            
            guard let data = data else { return completion(.failure(.dataError))}
            
            do {
                let item: Item = try JSONDecoder().decode(Item.self, from: data)
                completion(.success(item))
            } catch {
                print(error)
                completion(.failure(.parseError))
            }
        }
        
        dataTask.resume()
    }
}
