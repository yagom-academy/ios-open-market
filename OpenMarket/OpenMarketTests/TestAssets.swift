//
//  TestAsset.swift
//  OpenMarketTests
//
//  Created by Hailey, Ryan on 2021/05/19.
//

import UIKit.UIImage
@testable import OpenMarket

enum TestAssets {
    static let itemList: String = "items"
    static let item: String = "item"
    static let image = UIImage(named: "test_image")?.pngData()
    static let deleteBody = ItemForDelete(password: "1234")
    static let editBody = ItemForEdit(
        title: "pencil",
        price: nil,
        descriptions: "apple pencil",
        currency: nil,
        stock: nil,
        discountedPrice: nil,
        images: nil,
        password: ""
    )
    static let postBody = ItemForRegistration(
        title: "pencil",
        descriptions: "apple pencil",
        price: 1690000,
        currency: "KRW",
        stock: 1000000000000,
        discountedPrice: nil,
        images: [image!],
        password: "1234"
    )
    static let mockItemResponse = ItemResponse(
        id: 1,
        title: "pencil",
        descriptions: "apple pencil",
        price: 1690000,
        currency: "KRW",
        stock: 1000000000000,
        discountedPrice: nil,
        thumbnails: [
        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
    ],
        images: [
        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
    ],
        registrationDate: 1611523563.719116
    )
    static let loadingString: String = "Loading"
    static let requestErrorString: String = "Request was not successful: "
}
