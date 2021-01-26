//
//  MarketItemTests.swift
//  OpenMarketTests
//
//  Created by Kyungmin Lee on 2021/01/26.
//

import XCTest
@testable import OpenMarket

class MarketItemDecodeTests: XCTestCase {

    private var decodedMarketItem: MarketItem?
    private var decodedMarketItemWithoutImages: MarketItem?
    
    override func setUp() {
        guard let mockDataAsset = NSDataAsset(name: "item") else {
            XCTFail("Failed to load dataAsset")
            return
        }
        guard let mockWithoutImagesDataAsset = NSDataAsset(name: "itemWithoutImages") else {
            XCTFail("Failed to load dataAsset")
            return
        }
        if let decodedData: MarketItem = try? JSONDecoder().decode(MarketItem.self, from: mockDataAsset.data) {
            decodedMarketItem = decodedData
        } else {
            XCTFail("Failed to decode dataAsset")
            return
        }
        if let decodedData: MarketItem = try? JSONDecoder().decode(MarketItem.self, from: mockWithoutImagesDataAsset.data) {
            decodedMarketItemWithoutImages = decodedData
        } else {
            XCTFail("Failed to decode dataAsset")
            return
        }
    }
       
    func testDecodeMarketItemWithMock() {
        guard let decodedMarketItem = self.decodedMarketItem else {
            XCTFail("Failed to decode dataAsset")
            return
        }
        guard let images = decodedMarketItem.images else {
            XCTFail("Failed to decode dataAsset")
            return
        }
        
        XCTAssertEqual(decodedMarketItem.id, 1)
        XCTAssertEqual(decodedMarketItem.title, "MacBook Air")
        XCTAssertEqual(decodedMarketItem.descriptions, "가장 얇고 가벼운 MacBook이 Apple M1 칩으로 완전히 새롭게 탈바꿈했습니다. 최대 3.5배 빨라진 CPU. 최대 5배 빨라진 GPU. 머신 러닝을 전보다 최대 9배 빠른 속도로 구동해주는 최첨단 Neural Engine. MacBook Air 사상 가장 긴 배터리 사용 시간. 그리고 조용한 팬리스 디자인까지. 이토록 놀라운 파워를 이토록 뛰어난 휴대성에 담아 최초로 선보입니다.\n드디어 찾아왔습니다. Mac용으로 Apple에서 직접 디자인한 최초의 칩. 160억 개라는 엄청난 수의 트랜지스터가 집적되어 있는 Apple M1 시스템 온 칩(SoC, System on Chip)은 자그마한 칩 하나에 CPU, GPU, Neural Engine, I/O 등 수많은 요소가 통합되어 있습니다. 놀라운 성능과 맞춤형 테크놀로지, 업계 최고 수준의 전력 효율을 자랑하는1 M1은 Mac의 성능을 단지 한 단계 높이는 것이 아니라 완전히 새로운 경지로 끌어올려주죠.\n2560 x 1600 해상도의 선명한 13.3형 Retina 디스플레이에서 이미지는 한 차원 높은 디테일로 생생하게 살아납니다. 텍스트는 더욱 또렷하고 선명하게 보이고, 컬러는 그 어느 때보다 강력한 생동감을 자아내죠. 게다가 글래스가 외장 가장자리까지 뻗어있기 때문에 그 어떤 시각적 방해 요소 없이 아름다운 화면을 온전히 감상할 수 있습니다.")
        XCTAssertEqual(decodedMarketItem.price, 1290000)
        XCTAssertEqual(decodedMarketItem.currency, "KRW")
        XCTAssertEqual(decodedMarketItem.stock, 1000000000000)
        XCTAssertEqual(decodedMarketItem.discountedPrice, nil)
        for i in 0...2 {
            XCTAssertEqual(decodedMarketItem.thumbnails[i], "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-\(i + 1).png")
        }
        for i in 0...4 {
            XCTAssertEqual(images[i], "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-\(i + 1).png")
        }
        XCTAssertEqual(decodedMarketItem.registrationDate, 1611523563.719116)
    }
    
    func testDecodeMarketItemWithMockWithoutImages() {
        guard let decodedMarketItemWithoutImages = self.decodedMarketItemWithoutImages else {
            XCTFail("Failed to decode dataAsset")
            return
        }
        guard decodedMarketItemWithoutImages.images == nil else {
            XCTFail("Failed to decode dataAsset")
            return
        }
        
        XCTAssertEqual(decodedMarketItemWithoutImages.id, 1)
        XCTAssertEqual(decodedMarketItemWithoutImages.title, "MacBook Air")
        XCTAssertEqual(decodedMarketItemWithoutImages.descriptions, "가장 얇고 가벼운 MacBook이 Apple M1 칩으로 완전히 새롭게 탈바꿈했습니다. 최대 3.5배 빨라진 CPU. 최대 5배 빨라진 GPU. 머신 러닝을 전보다 최대 9배 빠른 속도로 구동해주는 최첨단 Neural Engine. MacBook Air 사상 가장 긴 배터리 사용 시간. 그리고 조용한 팬리스 디자인까지. 이토록 놀라운 파워를 이토록 뛰어난 휴대성에 담아 최초로 선보입니다.\n드디어 찾아왔습니다. Mac용으로 Apple에서 직접 디자인한 최초의 칩. 160억 개라는 엄청난 수의 트랜지스터가 집적되어 있는 Apple M1 시스템 온 칩(SoC, System on Chip)은 자그마한 칩 하나에 CPU, GPU, Neural Engine, I/O 등 수많은 요소가 통합되어 있습니다. 놀라운 성능과 맞춤형 테크놀로지, 업계 최고 수준의 전력 효율을 자랑하는1 M1은 Mac의 성능을 단지 한 단계 높이는 것이 아니라 완전히 새로운 경지로 끌어올려주죠.\n2560 x 1600 해상도의 선명한 13.3형 Retina 디스플레이에서 이미지는 한 차원 높은 디테일로 생생하게 살아납니다. 텍스트는 더욱 또렷하고 선명하게 보이고, 컬러는 그 어느 때보다 강력한 생동감을 자아내죠. 게다가 글래스가 외장 가장자리까지 뻗어있기 때문에 그 어떤 시각적 방해 요소 없이 아름다운 화면을 온전히 감상할 수 있습니다.")
        XCTAssertEqual(decodedMarketItemWithoutImages.price, 1290000)
        XCTAssertEqual(decodedMarketItemWithoutImages.currency, "KRW")
        XCTAssertEqual(decodedMarketItemWithoutImages.stock, 1000000000000)
        XCTAssertEqual(decodedMarketItemWithoutImages.discountedPrice, nil)
        for i in 0...2 {
            XCTAssertEqual(decodedMarketItemWithoutImages.thumbnails[i], "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-\(i + 1).png")
        }
        XCTAssertEqual(decodedMarketItemWithoutImages.registrationDate, 1611523563.719116)
    }
}

