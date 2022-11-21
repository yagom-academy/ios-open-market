//  Created by Aejong, Tottale on 2022/11/17.

import Foundation

enum MockData {
    
    static var sampleData: Data {
        Data(
            """
            {
               "pageNo":1,
               "itemsPerPage":10,
               "totalCount":111,
               "offset":0,
               "limit":10,
               "lastPage":12,
               "hasNext":true,
               "hasPrev":false,
               "pages":[
                  {
                     "id":196,
                     "vendor_id":13,
                     "vendorName":"mimm123",
                     "name":"Test",
                     "description":"Test Test Test Test Test Test Test Test Test",
                     "thumbnail":"https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/13/20221116/2576dce165c611eda917ed1dc9e4a299_thumb.jpeg",
                     "currency":"KRW",
                     "price":300000000,
                     "bargain_price":100000000,
                     "discounted_price":200000000,
                     "stock":1,
                     "created_at":"2022-11-16T00:00:00",
                     "issued_at":"2022-11-16T00:00:00"
                  }
               ]
            }
            """.utf8
        )
    }
}
