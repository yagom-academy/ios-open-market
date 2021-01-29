//
//  DeleteGoods.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/01/29.
//

import Foundation

struct DeleteGoods {
    private let task = NetworkTask(dispatcher: NetworkDispatcher())
    
    class DeleteGoodsRequest: Request {
        var path: String = NetworkConfig.openMarketFixedURL
        var method: HTTPMethod = .delete
        var headers: [String : String]? = NetworkConfig.jsonContentType
        var bodyParams: [String : Any]?
        var id: UInt
        
        init(id: UInt, params: DeleteGoodsForm) {
            self.id = id
            self.path.append(NetworkConfig.makeURLPath(api: .removeGoods, with: self.id))
            self.bodyParams = params.convertParameter()
        }
    }
    
    func requestDeleteGoods(params: DeleteGoodsForm, completion: @escaping(Result<Any, Error>) -> Void) {
        task.perform(request: DeleteGoodsRequest(id: params.id, params: params), dataType: Int.self) { result in
            switch result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
