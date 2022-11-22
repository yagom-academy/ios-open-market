//
//  OpenMarket - MockData.swift
//  Created by Zhilly, Dragon. 22/11/17
//  Copyright © yagom. All rights reserved.
//

import Foundation.NSData

enum MockData {
    static var data: Data {
        Data(
            """
            {
                "pageNo": 1,
                "itemsPerPage": 2,
                "totalCount": 3,
                "offset": 4,
                "limit": 5,
                "lastPage": 6,
                "hasNext": false,
                "hasPrev": false,
                "pages": [
                    {
                        "id": 11,
                        "vendor_id": 29,
                        "vendorName": "wongbing",
                        "name": "name test",
                        "description": "Post테스트용",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/29/20221116/e0e33c9e657911eda917131deaf687f6_thumb.png",
                        "currency": "KRW",
                        "price": 1200.0,
                        "bargain_price": 1200.0,
                        "discounted_price": 0.0,
                        "stock": 3,
                        "created_at": "2022-11-16T00:00:00",
                        "issued_at": "2022-11-16T00:00:00"
                    }
                ]
            }
            """.utf8
        )
    }
}
