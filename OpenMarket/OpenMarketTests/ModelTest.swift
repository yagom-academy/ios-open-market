//
//  test.swift
//  OpenMarketTests
//
//  Created by 최정민 on 2021/05/11.
//

import XCTest

@testable import OpenMarket
class ModelTest: XCTestCase {
    
    func testGetItemPageResponse() throws {
        let json = """
                    {
                        "page": 1,
                        "items": [
                            {
                                "id": 1,
                                "title": "MacBook Pro",
                                "price": 1690,
                                "currency": "USD",
                                "stock": 0,
                                "discounted_price": 100,
                                "thumbnails": [
                                    "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
                                    "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
                                    ],
                                "registration_date": 1611523563.7237701
                            }
                        ]
                    }
            """
        let jsonData = json.data(using: .utf8)!
        let getItemPageResponse = try JSONDecoder().decode(GetItemPageResponse.self, from: jsonData)
        XCTAssertEqual(getItemPageResponse.page, 1)
        XCTAssertEqual(getItemPageResponse.items[0].id, 1)
        XCTAssertEqual(getItemPageResponse.items[0].title, "MacBook Pro")
        XCTAssertEqual(getItemPageResponse.items[0].price, 1690)
        XCTAssertEqual(getItemPageResponse.items[0].currency, "USD")
        XCTAssertEqual(getItemPageResponse.items[0].stock, 0)
        XCTAssertEqual(getItemPageResponse.items[0].discountedPrice, 100)
        XCTAssertEqual(getItemPageResponse.items[0].thumbnails, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
            ])
        XCTAssertEqual(getItemPageResponse.items[0].registrationDate, 1611523563.7237701)
        
    }
    
    func testPostItemRequest() throws {
        
        let json = """
                {
                    "title": "MacBook Pro",
                    "descriptions": "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.",
                    "price": 1690000,
                    "currency": "KRW",
                    "stock": 1000000000000,
                    "images": [
                    "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
                    "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
                    ],
                    "password": "password"
                }
            """

        let jsonData = json.data(using: .utf8)!
        let postItemRequestData = try JSONDecoder().decode(PostItemRequest.self, from: jsonData)
    
        XCTAssertEqual(postItemRequestData.title, "MacBook Pro")
        XCTAssertEqual(postItemRequestData.price, 1690000)
        XCTAssertEqual(postItemRequestData.currency, "KRW")
        XCTAssertEqual(postItemRequestData.stock, 1000000000000)
        XCTAssertEqual(postItemRequestData.discountedPrice, nil)
        XCTAssertEqual(postItemRequestData.images, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
        ])
        XCTAssertEqual(postItemRequestData.password, "password")

    }
    
    func testPostItemResponse() throws {
   
        let json = """
                {
                    "id": 1,
                    "title": "MacBook Pro",
                    "descriptions": "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.",
                    "price": 1690000,
                    "currency": "KRW",
                    "stock": 1000000000000,
                    "discounted_price" : 1,
                    "thumbnails": [
                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
                        ],
                    "images": [
                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
                        ],
                    "registration_date": 1611523563.719116
                }
            """
        
        let jsonData = json.data(using: .utf8)!
        let postItemResponseData = try JSONDecoder().decode(PostItemResponse.self, from: jsonData)
        
        XCTAssertEqual(postItemResponseData.id, 1)
        XCTAssertEqual(postItemResponseData.title, "MacBook Pro")
        XCTAssertEqual(postItemResponseData.price, 1690000)
        XCTAssertEqual(postItemResponseData.currency, "KRW")
        XCTAssertEqual(postItemResponseData.stock, 1000000000000)
        XCTAssertEqual(postItemResponseData.discountedPrice, 1)
        XCTAssertEqual(postItemResponseData.thumbnails, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
            ])
        XCTAssertEqual(postItemResponseData.images, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
        ])
        XCTAssertEqual(postItemResponseData.registrationDate, 1611523563.719116)
    }
    
    func testGetItemIdentityResponse() throws {

        let json = """
                {
                    "id": 1,
                    "title": "MacBook Pro",
                    "descriptions": "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.",
                    "price": 1690000,
                    "currency": "KRW",
                    "stock": 1000000000000,
                    "discounted_price" : 1,
                    "thumbnails": [
                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
                        ],
                    "images": [
                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
                        ],
                    "registration_date": 1611523563.719116
                }
            """
        
        let jsonData = json.data(using: .utf8)!
        let getItemIdentityResponseData = try JSONDecoder().decode(GetItemIdentityResponse.self, from: jsonData)
        XCTAssertEqual(getItemIdentityResponseData.id, 1)
        XCTAssertEqual(getItemIdentityResponseData.title, "MacBook Pro")
        XCTAssertEqual(getItemIdentityResponseData.price, 1690000)
        XCTAssertEqual(getItemIdentityResponseData.currency, "KRW")
        XCTAssertEqual(getItemIdentityResponseData.stock, 1000000000000)
        XCTAssertEqual(getItemIdentityResponseData.discountedPrice, 1)
        XCTAssertEqual(getItemIdentityResponseData.thumbnails, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
            ])
        XCTAssertEqual(getItemIdentityResponseData.images, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
        ])
        XCTAssertEqual(getItemIdentityResponseData.registrationDate, 1611523563.719116)
    }

    func testPatchItemIdentityRequest() throws {
            let json = """
                    {
                        "title": "MacBook Pro",
                        "descriptions": "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.",
                        "price": 1690000,
                        "currency": "KRW",
                        "stock": 1000000000000,
                        "discounted_price" : 1,
                        "images": [
                            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
                            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
                            ],
                        "password": "password"
                    }
                """
            let jsonData = json.data(using: .utf8)!
            let patchItemIdentityRequestData = try JSONDecoder().decode(PatchItemIdentityRequest.self, from: jsonData)
            XCTAssertEqual(patchItemIdentityRequestData.title, "MacBook Pro")
            XCTAssertEqual(patchItemIdentityRequestData.descriptions, "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.")
            XCTAssertEqual(patchItemIdentityRequestData.price, 1690000)
            XCTAssertEqual(patchItemIdentityRequestData.currency, "KRW")
            XCTAssertEqual(patchItemIdentityRequestData.stock, 1000000000000)
            XCTAssertEqual(patchItemIdentityRequestData.discountedPrice, 1)
            XCTAssertEqual(patchItemIdentityRequestData.images, [
                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
                "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
                ])
            XCTAssertEqual(patchItemIdentityRequestData.password, "password")
            
        }

    func testPatchItemIdentityResponse() throws {

        let json = """
                {
                    "id": 1,
                    "title": "MacBook Pro",
                    "descriptions": "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.",
                    "price": 1690000,
                    "currency": "KRW",
                    "stock": 1000000000000,
                    "discounted_price" : 1,
                    "thumbnails": [
                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
                        ],
                    "images": [
                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
                        ],
                    "registration_date": 1611523563.719116
                }
            """
        let jsonData = json.data(using: .utf8)!
        let patchItemIdentityResponseData = try JSONDecoder().decode(PatchItemIdentityResponse.self, from: jsonData)
        XCTAssertEqual(patchItemIdentityResponseData.id, 1)
        XCTAssertEqual(patchItemIdentityResponseData.title, "MacBook Pro")
        XCTAssertEqual(patchItemIdentityResponseData.price, 1690000)
        XCTAssertEqual(patchItemIdentityResponseData.currency, "KRW")
        XCTAssertEqual(patchItemIdentityResponseData.stock, 1000000000000)
        XCTAssertEqual(patchItemIdentityResponseData.discountedPrice, 1)
        XCTAssertEqual(patchItemIdentityResponseData.thumbnails, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
            ])
        XCTAssertEqual(patchItemIdentityResponseData.images, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
        ])
        XCTAssertEqual(patchItemIdentityResponseData.registrationDate, 1611523563.719116)
    }

    func testDeleteItemIdentityRequest() throws {
            let json = """
                    {
                        "password": "password"
                    }
                """
            let jsonData = json.data(using: .utf8)!
            let deleteItemIdentityRequestData = try JSONDecoder().decode(DeleteItemIdentityRequest.self, from: jsonData)
            XCTAssertEqual(deleteItemIdentityRequestData.password, "password")
        }

    func testDeleteItemIdentityResponse() throws {

        let json = """
                {
                    "id": 1,
                    "title": "MacBook Pro",
                    "descriptions": "Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.",
                    "price": 1690000,
                    "currency": "KRW",
                    "stock": 1000000000000,
                    "discounted_price" : 1,
                    "thumbnails": [
                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
                        ],
                    "images": [
                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
                        "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
                        ],
                    "registration_date": 1611523563.719116
                }
            """
        let jsonData = json.data(using: .utf8)!
        let deleteItemIdentityResponseData = try JSONDecoder().decode(DeleteItemIdentityResponse.self, from: jsonData)
        XCTAssertEqual(deleteItemIdentityResponseData.id, 1)
        XCTAssertEqual(deleteItemIdentityResponseData.title, "MacBook Pro")
        XCTAssertEqual(deleteItemIdentityResponseData.price, 1690000)
        XCTAssertEqual(deleteItemIdentityResponseData.currency, "KRW")
        XCTAssertEqual(deleteItemIdentityResponseData.stock, 1000000000000)
        XCTAssertEqual(deleteItemIdentityResponseData.discountedPrice, 1)
        XCTAssertEqual(deleteItemIdentityResponseData.thumbnails, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
            ])
        XCTAssertEqual(deleteItemIdentityResponseData.images, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
        ])
        XCTAssertEqual(deleteItemIdentityResponseData.registrationDate, 1611523563.719116)
    }
}
