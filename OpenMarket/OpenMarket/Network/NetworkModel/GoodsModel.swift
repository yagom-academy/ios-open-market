//
//  GoodsModel.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/02.
//

import Foundation

struct GoodsModel {
    typealias GoodsFormParameter = [String : Any]
    
    private static let task = NetworkTask(dispatcher: NetworkDispatcher())
    
    private class GoodsModelRequest: Request {
        var id: UInt?
        var path: String = NetworkConfig.openMarketFixedURL
        var method: HTTPMethod
        var headers: [String : String]?
        var bodyParams: [String : Any]?
        
        init(fetchID: UInt) {
            self.id = fetchID
            self.path.append(NetworkConfig.makeURLPath(api: .fetchGoods, with: fetchID))
            self.method = .get
        }
        
        init(registerParams: GoodsFormParameter) {
            self.path.append(NetworkConfig.makeURLPath(api: .registerGoods, with: nil))
            self.method = .post
            self.headers = NetworkConfig.multipartContentType
            self.bodyParams = registerParams
        }
        
        init(editParams: GoodsFormParameter,
             editID: UInt) {
            self.path.append(NetworkConfig.makeURLPath(api: .editGoods, with: editID))
            self.method = .patch
            self.headers = NetworkConfig.multipartContentType
            self.bodyParams = editParams
        }
        
        init(deleteParams: GoodsFormParameter,
             deleteID: UInt) {
            self.path.append(NetworkConfig.makeURLPath(api: .deleteGoods, with: deleteID))
            self.method = .delete
            self.headers = NetworkConfig.jsonContentType
            self.bodyParams = deleteParams
        }
    }
    
    static func fetchGoods(id: UInt, completion: @escaping(Result<Any, Error>) -> Void) {
        task.perform(request: GoodsModelRequest(fetchID: id), dataType: Goods.self) { result in
            switch result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func registerGoods(params: GoodsFormParameter, completion: @escaping(Result<Any, Error>) -> Void) {
        task.perform(request: GoodsModelRequest(registerParams: params), dataType: Goods.self) { result in
            switch result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func editGoods(id: UInt, params: GoodsFormParameter, completion: @escaping(Result<Any, Error>) -> Void) {
        task.perform(request: GoodsModelRequest(editParams: params, editID: id), dataType: Goods.self) { result in
            switch result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func deleteGoods(id: UInt, params: GoodsFormParameter, completion: @escaping(Result<Any, Error>) -> Void) {
        task.perform(request: GoodsModelRequest(deleteParams: params, deleteID: id), dataType: [String : UInt].self) { result in
            switch result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
