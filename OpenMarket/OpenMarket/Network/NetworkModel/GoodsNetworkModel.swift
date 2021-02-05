//
//  GoodsModel.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/02.
//

import Foundation

struct GoodsNetworkModel {
    typealias GoodsFormParameter = [String : Any]
    
    private static let task = NetworkTask(dispatcher: NetworkDispatcher())
    
    private class GoodsModelRequest: Request {
        var id: UInt?
        var path: String = NetworkConfig.openMarketFixedURL
        var method: HTTPMethod
        var headers: [String : String]?
        var bodyParams: Data?
        var boundary: String?
        
        init(idToFetch: UInt) {
            self.id = idToFetch
            self.path.append(NetworkConfig.makeURLPath(api: .fetchGoods, with: idToFetch))
            self.method = .get
        }
        
        init(registerParams: GoodsFormParameter) {
            self.path.append(NetworkConfig.makeURLPath(api: .registerGoods, with: nil))
            self.method = .post
            self.boundary = UUID().uuidString
            self.headers = ["Content-Type" : String(format: HeaderType.multipartForm, self.boundary ?? "")]
            self.bodyParams = GoodsForm.makeBodyData(with: registerParams, boundary: self.boundary ?? "")
        }
        
        init(editParams: GoodsFormParameter,
             editID: UInt) {
            self.path.append(NetworkConfig.makeURLPath(api: .editGoods, with: editID))
            self.method = .patch
            self.boundary = UUID().uuidString
            self.headers = ["Content-Type" : String(format: HeaderType.multipartForm, self.boundary ?? "")]
            self.bodyParams = GoodsForm.makeBodyData(with: editParams, boundary: self.boundary ?? "")
        }
        
        init(deleteParams: GoodsFormParameter,
             deleteID: UInt) {
            self.path.append(NetworkConfig.makeURLPath(api: .deleteGoods, with: deleteID))
            self.method = .delete
            self.headers = ["Content-Type" : HeaderType.json]
            self.bodyParams = try? JSONSerialization.data(withJSONObject: deleteParams)
        }
    }
    
    static func fetchGoods(id: UInt, completion: @escaping(Result<Goods, Error>) -> Void) {
        task.perform(request: GoodsModelRequest(idToFetch: id), dataType: Goods.self) { result in
            switch result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func registerGoods(params: GoodsFormParameter, completion: @escaping(Result<Goods, Error>) -> Void) {
        task.perform(request: GoodsModelRequest(registerParams: params), dataType: Goods.self) { result in
            switch result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func editGoods(id: UInt, params: GoodsFormParameter, completion: @escaping(Result<Goods, Error>) -> Void) {
        task.perform(request: GoodsModelRequest(editParams: params, editID: id), dataType: Goods.self) { result in
            switch result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func deleteGoods(id: UInt, params: GoodsFormParameter, completion: @escaping(Result<[String : UInt], Error>) -> Void) {
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
