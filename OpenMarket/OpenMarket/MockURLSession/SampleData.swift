//
//  SampleData.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/16.
//

import UIKit

enum SampleData {
    static var sampleData: Data {
        Data(
            """
            {
              "pageNo": 1,
              "itemsPerPage": 1,
              "totalCount": 114,
              "offset": 0,
              "limit": 1,
              "lastPage": 114,
              "hasNext": true,
              "hasPrev": false,
              "pages": [
                {
                  "id": 195,
                  "vendor_id": 29,
                  "vendorName": "wongbing",
                  "name": "테스트",
                  "description": "Post테스트용",
                  "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/29/20221116/e0e33c9e657911eda917131deaf687f6_thumb.png",
                  "currency": "KRW",
                  "price": 1200,
                  "bargain_price": 1200,
                  "discounted_price": 0,
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
