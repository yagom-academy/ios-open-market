//
//  ListLookUpTask.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/09/03.
//

import Foundation

class ListLookUpTask {
    var items: [Item] = []
    
    func lookUpItemList(page: Int, in networkDispatcher: NetworkDispatcher) {
        networkDispatcher.send(request: Request.getList, page) { result in
            switch result {
            case .success(let data):
                guard let itemList = try? JSONDecoder().decode(ItemList.self, from: data) else {
                    return
                }
                self.items.append(contentsOf: itemList.items)
            case .failure(let error):
                print(error)
            }
        }
    }
}
