//
//  FetchMarketGoods.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/01/29.
//

import Foundation

struct FetchMarketGoodsList {
    private let task = NetworkTask(dispatcher: NetworkDispatcher())
    
    class FetchMarketGoodsListRequest: Request {
        var path: String = OpenMarketURL.openMarketFixedURL
        var method: HTTPMethod = .get
        var page: UInt
        
        init(page: UInt) {
            self.page = page
            self.path.append(OpenMarketURL.makeURLPath(api: .fetchGoodsList, with: self.page))
        }
    }
    
    func requestFetchMarketGoodsList(page: UInt, completion: @escaping(Result<Any, Error>) -> Void) {
        task.perform(request: FetchMarketGoodsListRequest(page: page), dataType: MarketGoods.self) { result in
            switch result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
