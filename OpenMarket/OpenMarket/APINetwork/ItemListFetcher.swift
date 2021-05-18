//
//  GetItem.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/12.
//

import Foundation

class ItemListFetcher {
    
    private var page = 1
    var itemList: ItemList?
    
    func fetchItemList() throws {
        let url = OpenMarketAPI.baseURL + OpenMarketAPIPathByDescription.itemListSearch.description + "\(self.page)"
        guard let apiURI = URL(string: url) else { throw APIError.NotFound404Error }
        
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: apiURI, completionHandler: { data, response, error in
            guard let data = data, error == nil else { return }
            var result: ItemList?
            result = try? JSONDecoder().decode(ItemList.self, from: data)
            self.itemList = result
            semaphore.signal()
        })
        task.resume()
        semaphore.wait()
    }
}
