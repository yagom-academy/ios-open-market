//
//  MockData.swift
//  OpenMarketTests
//
//  Created by 권나영 on 2022/01/07.
//

import Foundation

enum MockRequest {
    case getPage
    case getProduct
    
    var data: Data {
        switch self {
        case .getPage:
            return Data(MockRequest.getPageData)
        case .getProduct:
            return Data(MockRequest.getProductData)
        }
    }
}

extension MockRequest {
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
    
}
