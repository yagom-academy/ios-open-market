//
//  TestData.swift
//  OpenMarketTests
//
//  Created by 윤재웅 on 2021/05/20.
//

import Foundation
import UIKit
@testable import OpenMarket

struct StubMarketItems: Decodable { }
struct StubMarketItem: Decodable { }

enum TestData {
    static let image = UIImage(named: "kanekane")?.pngData()
    static let password = ItemDelete(password: "1234")
    static let registrateData = ItemUpload(title: "TicTekTak",
                                        descriptions: "탁탁탁탁",
                                        price: 250,
                                        currency: "KOR",
                                        stock: 2,
                                        discountedPrice: nil,
                                        images: [image!],
                                        password: "1234")
    static let editData = ItemDetailUpload(title: "kanekane",
                                           descriptions: "케케케인",
                                           price: nil,
                                           currency: nil,
                                           stock: 1,
                                           discountedPrice: 90,
                                           images: nil,
                                           password: "1234")
}
