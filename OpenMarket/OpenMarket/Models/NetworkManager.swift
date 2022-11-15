//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 스톤, 로빈 on 2022/11/15.
//

import Foundation

struct NetworkManager {
    func fetchItemList(completion: @escaping (ItemList) -> ()) {
        guard let url: URL = URL(string: "https://openmarket.yagom-academy.kr/api/products?page_no=1&items_per_page=100") else { return }
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                print("statusCode error")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let itemList: ItemList = try JSONDecoder().decode(ItemList.self, from: data)
                completion(itemList)
            } catch {
                print(error)
            }
            
        }
        
        dataTask.resume()
    }
}
