//
//  EditGoods.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/01/29.
//

import Foundation

struct EditGoods {
    private let task = NetworkTask(dispatcher: NetworkDispatcher())
    
    class EditGoodsRequest: Request {
        var path: String = NetworkConfig.openMarketFixedURL
        var method: HTTPMethod = .patch
        var headers: [String : String]? = NetworkConfig.jsonContentType
        var bodyParams: Data?
        var id: UInt
        
        init(params: EditForm, id: UInt) {
            self.id = id
            self.path.append(NetworkConfig.makeURLPath(api: .editGoods, with: id))
            self.bodyParams = try? JSONEncoder().encode(params)
        }
    }
    
    func requestEditGoods(params: EditForm, completion: @escaping(Result<Any, Error>) -> Void) {
        task.perform(request: EditGoodsRequest(params: params, id: params.id), dataType: Goods.self) { result in
            switch result {
            case .success(let decodedData):
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

class EditForm: EditGoodsForm, Encodable {
    var title: String?
    var descriptions: String?
    var price: Int?
    var currency: String?
    var stock: Int?
    var discountedPrice: Int?
    var images: [Data]?
    var id: UInt
    var password: String
    
    required init(title: String?, descriptions: String?, price: Int?, currency: String?, stock: Int?, discountedPrice: Int?, images: [Data]?, id: UInt, password: String) {
        self.title = title
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discountedPrice = discountedPrice
        self.images = images
        self.id = id
        self.password = password
    }
    
    enum CodingKeys: String, CodingKey {
        case title, descriptions, price, currency, stock, images, password
        case discountedPrice = "discouonted_price"
    }
}
