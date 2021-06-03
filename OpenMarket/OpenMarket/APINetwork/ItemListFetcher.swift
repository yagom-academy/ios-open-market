//
//  GetItem.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/12.
//

import Foundation

struct ItemListFetcher {
    
    private var page = 1
    
    mutating func fetchItemList(completion: @escaping (GETResponseItemList?) -> () ) throws {
        
        let url = OpenMarketAPIPath.itemListSearch.path + "\(self.page)"
        guard let apiURI = URL(string: url) else { throw APIError.InvalidAddressError }
        
        let task = URLSession.shared.dataTask(with: apiURI) { data, response, error in
            // 에러처리
            guard let data = data else { return }
            let fetchedItemList = try? JSONDecoder().decode(GETResponseItemList.self, from: data)
            completion(fetchedItemList)
        }
        task.resume()
    }
}
