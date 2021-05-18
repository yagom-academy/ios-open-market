//
//  ItemDetailFetcher.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/14.
//

import Foundation

class ItemDetailFetcher {
    // static으로 하는 것이 나을지, 매번 디테일을 들어갈 때 인스턴스를 생성하는 것이 나을지
    var id: UInt?
    var item: Item?
    
    init(id: UInt) {
        self.id = id
    }
    
    func fetchItemDetail() throws {
        // Optional이므로 그냥 self.id면 노란 이슈 발생. String describing을 하면 되긴 하는데 init에서 초기화하고 나서 작동하므로 메소드가 동작하는 시점에 nil이 들어갈 일은 없어보이지만 에러가 발생해서 lazy를 했는데 let이라 lazy가 안됨
        let url = OpenMarketAPI.baseURL + OpenMarketAPIPathByDescription.itemSearch.description + "\(String(describing: self.id))"
        guard let apiURI = URL(string: url) else { throw APIError.NotFound404Error }
        
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: apiURI, completionHandler: { data, response, error in
            guard let data = data, error == nil else { return }
            var result: Item?
            do {
                result = try JSONDecoder().decode(Item.self, from: data)
            } catch {
                // Error를 throw하려면 extension으로 throw 가능한 메소드로 override 해야하나?
                print("JSON Parsing Error")
            }
            // 이 구문이 없으면 result가 정상적으로 동작했는지 알 수 없다. 위에서 Error 핸들링이 가능하다면 없어도 될지도?
            guard let json = result else {
                return
            }
            self.item = json
            semaphore.signal()
        })
        task.resume()
        semaphore.wait()
    }
}
