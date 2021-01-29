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
        var bodyParams: Data?
        var id: UInt
        
        init(id: UInt, params: DeleteForm) {
            self.id = id
            self.path.append(NetworkConfig.makeURLPath(api: .removeGoods, with: self.id))
            self.bodyParams = try? JSONEncoder().encode(params)
        }
    }
    
    func requestDeleteGoods(params: DeleteForm, completion: @escaping(Result<Any, Error>) -> Void) {
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

class DeleteForm: DeleteGoodsForm, Encodable {
    var id: UInt
    var password: String
    
    required init(id: UInt, password: String) {
        self.id = id
        self.password = password
    }
}
