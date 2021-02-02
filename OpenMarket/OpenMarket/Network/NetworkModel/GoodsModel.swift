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
        var bodyParams: [String : Any]?
        
        init(fetchID: UInt) {
            self.id = fetchID
            self.path.append(NetworkConfig.makeURLPath(api: .fetchGoods, with: fetchID))
            self.method = .get
        }
        
        init(registerParams: GoodsForm) {
            self.path.append(NetworkConfig.makeURLPath(api: .registerGoods, with: nil))
            self.method = .post
            self.headers = NetworkConfig.multipartContentType
            self.bodyParams = registerParams.convertParameter
        }
        
        init(editParams: GoodsForm,
             editID: UInt) {
            self.path.append(NetworkConfig.makeURLPath(api: .editGoods, with: editID))
            self.method = .patch
            self.headers = NetworkConfig.multipartContentType
            self.bodyParams = editParams.convertParameter
        }
        
        init(deleteParams: GoodsForm,
             deleteID: UInt) {
            self.path.append(NetworkConfig.makeURLPath(api: .deleteGoods, with: deleteID))
            self.method = .delete
            self.headers = NetworkConfig.jsonContentType
            self.bodyParams = deleteParams.convertParameter
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
    
    func registerGoods(params: GoodsForm, completion: @escaping(Result<Any, Error>) -> Void) {
        task.perform(request: GoodsModelRequest(registerParams: params), dataType: Goods.self) { result in
            switch result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func editGoods(id: UInt, params: GoodsForm, completion: @escaping(Result<Any, Error>) -> Void) {
        task.perform(request: GoodsModelRequest(editParams: params, editID: id), dataType: Goods.self) { result in
            switch result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteGoods(id: UInt, params: GoodsForm, completion: @escaping(Result<Any, Error>) -> Void) {
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
