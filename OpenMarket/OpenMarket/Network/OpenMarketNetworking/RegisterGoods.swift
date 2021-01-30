//
//  RegisterGoods.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/01/29.
//

import Foundation

struct RegisterGoods {
    private let task = NetworkTask(dispatcher: NetworkDispatcher())
    
    class RegisterGoodsRequest: Request {
        var path: String = NetworkConfig.openMarketFixedURL
        var method: HTTPMethod = .post
        var headers: [String : String]? = NetworkConfig.jsonContentType
        var bodyParams: Data?
        
        init(params: RegisterForm) {
            self.path.append(NetworkConfig.makeURLPath(api: .registerGoods, with: nil))
            self.bodyParams = try? JSONEncoder().encode(params)
        }
    }
    
    func requestRegisterGoods(params: RegisterForm, completion: @escaping(Result<Any, Error>) -> Void) {
        task.perform(request: RegisterGoodsRequest(params: params), dataType: Goods.self) { result in
            switch result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

class RegisterForm: RegisterGoodsForm, Encodable {
    var title: String
    var descriptions: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var images: [Data]
    var password: String
    
    required init(title: String, descriptions: String, price: Int, currency: String, stock: Int, discountedPrice: Int?, images: [Data], password: String) {
        self.title = title
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discountedPrice = discountedPrice
        self.images = images
        self.password = password
    }
    
    enum CodingKeys: String, CodingKey {
        case title, descriptions, price, currency, stock, images, password
        case discountedPrice = "discouonted_price"
    }
}
