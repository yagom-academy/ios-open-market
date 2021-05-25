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
    static let deleteBody = Item(forDeletePassword: "1234")
    static let editBody = Item(
        forPatchPassword: "1234",
        title: "pencil",
        descriptions: "apple pencil",
        currency: nil,
        price: nil,
        discountedPrice: nil,
        stock: nil,
        imagesFiles: nil
    )
    static let postBody = Item(
        forPostPassword: "1234",
        title: "pencil",
        descriptions: "apple pencil",
        currency: "KRW",
        price: 1690000,
        discountedPrice: nil,
        stock: 1000000000000,
        imagesFiles: [image!]
    )
    static let mockItem = Item(
        forResponseID: 1,
        title: "pencil",
        descriptions: "apple pencil",
        currency: "KRW",
        price: 1690000,
        discountedPrice: nil,
        stock: 1000000000000,
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
