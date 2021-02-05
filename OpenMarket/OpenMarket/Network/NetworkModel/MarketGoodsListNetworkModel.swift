//
//  GoodsListModel.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/02.
//

import Foundation

struct MarketGoodsListNetworkModel {
    private static let task = NetworkTask(dispatcher: NetworkDispatcher())
    private class GoodsListModelRequest: Request {
        var page: UInt?
        var path: String = NetworkConfig.openMarketFixedURL
        var method: HTTPMethod
        
        init(fetchPage: UInt) {
            self.page = fetchPage
            self.path.append(NetworkConfig.makeURLPath(api: .fetchGoodsList, with: fetchPage))
            self.method = .get
        }
    }
    
    static func fetchMarketGoodsList(page: UInt, completion: @escaping(Result<MarketGoods, Error>) -> Void) {
        task.perform(request: GoodsListModelRequest(fetchPage: page), dataType: MarketGoods.self) { result in
            switch result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
