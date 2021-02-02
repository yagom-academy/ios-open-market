//
//  GoodsModel.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/02.
//

import Foundation

struct GoodsModel {
    private let task = NetworkTask(dispatcher: NetworkDispatcher())
    
    class GoodsModelRequest: Request {
        var id: UInt?
        var path: String = NetworkConfig.openMarketFixedURL
        var method: HTTPMethod
        var headers: [String : String]?
        var bodyParams: Data?
        
        init(fetchID: UInt) {
            self.id = fetchID
            self.path.append(NetworkConfig.makeURLPath(api: .fetchGoods, with: fetchID))
            self.method = .get
        }
        
        init(registerParams: GoodsForm) {
            self.path.append(NetworkConfig.makeURLPath(api: .registerGoods, with: nil))
            self.method = .post
            self.headers = NetworkConfig.multipartContentType
            
        }
    }
    
    func fetchGoods(id: UInt, completion: @escaping(Result<Any, Error>) -> Void) {
        task.perform(request: GoodsModelRequest(fetchID: id), dataType: Goods.self) { result in
            switch result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func registerGoods() {
        
    }
}
