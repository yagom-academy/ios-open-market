//
//  API.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/10.
//

enum API {
    static let hostApi = "https://market-training.yagom-academy.kr"
    static let productPath = "/api/products"
    static let healthCheckerPath = "/healthChecker"
    
    case productList(pageNo: Int, itemsPerPage: Int)
    case productDetail(productId: Int)
    case healthChecker
    
    func generateURL() -> String {
        switch self {
        case .productList(let pageNo, let itemsPerPage):
            return API.hostApi + API.productPath + "?page_no=\(pageNo)&items_per_page=\(itemsPerPage)"
        case .productDetail(let productId):
            return API.hostApi + API.productPath + "/\(productId)"
        case .healthChecker:
            return API.hostApi + API.healthCheckerPath
        }
    }
}
