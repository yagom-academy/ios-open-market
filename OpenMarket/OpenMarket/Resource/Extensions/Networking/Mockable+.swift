//
//  Mockable+.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.
        

import Foundation

protocol Mockable {
    static var mockData: Data? { get }
}

extension ProductListResponse: Mockable {
    static var mockData: Data? = """
    {
        "pageNo": 1,
        "itemsPerPage": 1,
        "totalCount": 112,
        "offset": 0,
        "limit": 1,
        "lastPage": 112,
        "hasNext": true,
        "hasPrev": false,
        "pages": [
            {
                "id": 208,
                "vendor_id": 29,
                "vendorName": "wongbing",
                "name": "테스트",
                "description": "Post테스트용",
                "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/29/20221118/5d06f05766db11eda917a9d79f703efd_thumb.png",
                "currency": "KRW",
                "price": 1200.0,
                "bargain_price": 1200.0,
                "discounted_price": 0.0,
                "stock": 3,
                "created_at": "2022-11-18T00:00:00",
                "issued_at": "2022-11-18T00:00:00"
            }
        ]
    }
    """.data(using: .utf8)
}

extension Product: Mockable {
    static var mockData: Data? {
        return """
            {
                "id": 208,
                "vendor_id": 29,
                "vendorName": "wongbing",
                "name": "테스트",
                "description": "Post테스트용",
                "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/29/20221118/5d06f05766db11eda917a9d79f703efd_thumb.png",
                "currency": "KRW",
                "price": 1200.0,
                "bargain_price": 1200.0,
                "discounted_price": 0.0,
                "stock": 3,
                "created_at": "2022-11-18T00:00:00",
                "issued_at": "2022-11-18T00:00:00"
            }
            """.data(using: .utf8)
    }
}
