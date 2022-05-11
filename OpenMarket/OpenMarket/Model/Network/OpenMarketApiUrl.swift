//
//  ApiUrl.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/11.
//

enum OpenMarketApiUrl {
    static let hostUrl = "https://market-training.yagom-academy.kr/"
     
    case pageInformation
    case productDetail(productNumber: Int)
    
    var string: String {
        switch self {
        case .pageInformation:
            return OpenMarketApiUrl.hostUrl + "api/products?"
        case .productDetail(let productNumber):
            return OpenMarketApiUrl.hostUrl + "api/products/\(productNumber)"
        }
    }
}
