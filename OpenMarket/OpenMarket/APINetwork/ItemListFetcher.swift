//
//  GetItem.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/12.
//

import Foundation

class ItemListFetcher {
    
    private var page = 1
    var itemList: ItemListVO?
    
    func fetchItemList() throws {
        let url = OpenMarketAPI.baseURL + OpenMarketAPIPathByDescription.itemListSearch.description + "\(self.page)"
        guard let apiURI = URL(string: url) else { throw APIError.NotFound404Error }
        
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: apiURI, completionHandler: { data, response, error in
            guard let data = data, error == nil else { return }
            var result: ItemListVO?
            result = try? JSONDecoder().decode(ItemListVO.self, from: data)
            self.itemList = result
            semaphore.signal()
        })
        task.resume()
        semaphore.wait()
    }
}
