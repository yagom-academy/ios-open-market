//
//  MockData.swift
//  OpenMarketTests
//
//  Created by 권나영 on 2022/01/07.
//

import Foundation

enum StubRequest {
    case getPage
    case getProduct
    case registerProduct
    case updateProduct
    
    var data: Data {
        switch self {
        case .getPage:
            return Data(StubRequest.getPageData)
        case .getProduct:
            return Data(StubRequest.getProductData)
        case .registerProduct:
            return Data(StubRequest.registerProductData)
        case .updateProduct:
            return Data(StubRequest.updateProductData)
        }
    }
}

extension StubRequest {
    static let getPageData = """
    {
    "page_no": 1,
    "items_per_page": 20,
    "total_count": 10,
    "offset": 0,
    "limit": 20,
    "pages": [
        {
            "id": 20,
            "vendor_id": 3,
            "name": "Test Product",
            "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/5a0cd56b6d3411ecabfa97fd953cf965.jpg",
            "currency": "KRW",
            "price": 0,
            "bargain_price": 0,
            "discounted_price": 0,
            "stock": 0,
            "created_at": "2022-01-04T00:00:00.00",
            "issued_at": "2022-01-04T00:00:00.00"
        }
    ],
    "last_page": 1,
    "has_next": false,
    "has_prev": false
    }
    """.utf8
    
    static let getProductData = """
    {
    "id": 87,
    "vendor_id": 3,
    "name": "aladdin",
    "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/b07b4b206eec11ecabfa73cd0451c065.jpeg",
    "currency": "KRW",
    "price": 0.0,
    "bargain_price": 0.0,
    "discounted_price": 0.0,
    "stock": 0,
    "created_at": "2022-01-06T00:00:00.00",
    "issued_at": "2022-01-06T00:00:00.00",
    "images": [
        {
            "id": 60,
            "url": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/origin/b07b4b206eec11ecabfa73cd0451c065.jpeg",
            "thumbnail_url": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/b07b4b206eec11ecabfa73cd0451c065.jpeg",
            "succeed": true,
            "issued_at": "2022-01-06T00:00:00.00"
        }
    ],
    "vendors": {
        "name": "Vendor2",
        "id": 3,
        "created_at": "2021-12-27T00:00:00.00",
        "issued_at": "2021-12-27T00:00:00.00"
        }
    }
    """.utf8
    
    static let registerProductData = """
    {
    "id": 536,
    "vendor_id": 3,
    "name": "zoe",
    "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/5b5a5f22790111ec9173b76aa80a2e69.jpeg",
    "currency": "KRW",
    "price": 0.0,
    "description": "desc",
    "bargain_price": 0.0,
    "discounted_price": 0.0,
    "stock": 0,
    "created_at": "2022-01-19T08:25:27.27",
    "issued_at": "2022-01-19T08:25:27.27",
    "images": [
        {
            "id": 365,
            "url": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/origin/5b5a5f22790111ec9173b76aa80a2e69.jpeg",
            "thumbnail_url": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/5b5a5f22790111ec9173b76aa80a2e69.jpeg",
            "succeed": true,
            "issued_at": "2022-01-19T08:25:27.27"
        }
    ],
    "vendors": {
        "name": "Vendor2",
        "id": 3,
        "created_at": "2021-12-27T00:00:00.00",
        "issued_at": "2021-12-27T00:00:00.00"
        }
    }
    """.utf8


    static let updateProductData = """
    {
    "id": 533,
    "vendor_id": 3,
    "name": "aladdin",
    "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/808a439c78f811ecabfafb03c5e0d3f1.jpeg",
    "currency": "KRW",
    "price": 100000.0,
    "description": "ㅇㅇㅇ",
    "bargain_price": 99900.0,
    "discounted_price": 100.0,
    "stock": 0,
    "created_at": "2022-01-19T00:00:00.00",
    "issued_at": "2022-01-19T00:00:00.00",
    "images": [
        {
            "id": 362,
            "url": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/origin/808a439c78f811ecabfafb03c5e0d3f1.jpeg",
            "thumbnail_url": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/808a439c78f811ecabfafb03c5e0d3f1.jpeg",
            "succeed": true,
            "issued_at": "2022-01-19T00:00:00.00"
        }
    ],
    "vendors": {
        "name": "Vendor2",
        "id": 3,
        "created_at": "2021-12-27T00:00:00.00",
        "issued_at": "2021-12-27T00:00:00.00"
        }
    }
    """.utf8
}
