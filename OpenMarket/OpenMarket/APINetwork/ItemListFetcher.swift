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
            do {
                result = try JSONDecoder().decode(ItemListVO.self, from: data)
            } catch {
                // Error를 throw하려면 extension으로 throw 가능한 메소드로 override 해야하나?
                print("JSON Parsing Error")
            }
            // 이 구문이 없으면 result가 정상적으로 동작했는지 알 수 없다. 위에서 Error 핸들링이 가능하다면 없어도 될지도?
            guard let json = result else {
                return
            }
            self.itemList = json
            semaphore.signal()
        })
        task.resume()
        semaphore.wait()
    }
}
