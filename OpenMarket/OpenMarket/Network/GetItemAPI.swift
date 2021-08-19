//
//  GetItemAPI.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/19.
//

import UIKit

struct GetItemAPI: Requestable {

    var format: ApiFormat = .getItems(page: 1)
    
    var contentType: ContentType = .json
    
    var parameter: [String : Any]?

    var items: [Media]? = Media(withImage: UIImage, forKey: <#T##String#>)
    
}
