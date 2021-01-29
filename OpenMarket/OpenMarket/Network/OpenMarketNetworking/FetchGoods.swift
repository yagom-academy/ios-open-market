//
//  FetchGoods.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/01/29.
//

import Foundation

struct FetchGoods {
    private let task = NetworkTask(dispatcher: NetworkDispatcher())
    
    class FetchGoodsRequest: Request {
        var path: String = NetworkConfig.openMarketFixedURL
        var method: HTTPMethod = .get
        var id: UInt
        
        init(id: UInt) {
            self.id = id
            self.path.append(NetworkConfig.makeURLPath(api: .fetchGoods, with: self.id))
        }
    }
    
    func requestFetchGoods(id: UInt, completion: @escaping(Result<Any, Error>) -> Void) {
        task.perform(request: FetchGoodsRequest(id: id), dataType: Goods.self) { result in
            switch result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
