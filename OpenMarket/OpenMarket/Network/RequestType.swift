//
//  RequestType.swift
//  OpenMarket
//
//  Created by Aaron, Jpush on 2022/11/30.
//

enum RequestType {
    case healthChecker
    case searchProductList(pageNo: Int, itemsPerPage: Int)
    case searchProductDetail(productNumber: Int)
    case patchProduct(number: Int)
}

