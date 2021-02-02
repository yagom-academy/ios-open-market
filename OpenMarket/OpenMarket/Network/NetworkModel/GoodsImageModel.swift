//
//  GoodsImageModel.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/02.
//

import Foundation

struct GoodsImageModel {
    private class GoodsImageModelRequest: Request {
        var path: String
        var method: HTTPMethod
        init(imagePath: String) {
            self.path = imagePath
            self.method = .get
        }
    }
    
    static func fetchImage(urlString: String, completion: @escaping(Result<Any, Error>) -> Void) {
        NetworkDispatcher().execute(request: GoodsImageModelRequest(imagePath: urlString)) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
