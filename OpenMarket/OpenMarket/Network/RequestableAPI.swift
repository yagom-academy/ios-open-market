//
//  GetItemAPI.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/19.
//

import UIKit

struct GetItemAPI: RequestableWithoutBody {
    var url: String
    var method: APIMethod = .get
    var contentType: ContentType = .json
    
    init(id: Int) {
            self.url = APIURL.getItem.description + "\(id)"
    }
}

struct GetItemsAPI: RequestableWithoutBody {
    var url: String
    var method: APIMethod = .get
    var contentType: ContentType = .json
    
    init(page: Int) {
            self.url = APIURL.getItems.description + "\(page)"
    }
}

struct PostAPI: RequestableWithBody {
    var url: String = APIURL.post.description
    var method: APIMethod = .post
    var contentType: ContentType = .multipart
    var parameter: [String : Any]?
    var items: [Media]?

    init(parameter: [String : Any], items: [Media]) {
        self.parameter = parameter
        self.items = items
    }
}

struct PatchAPI: RequestableWithBody {
    var url: String
    var method: APIMethod = .patch
    var contentType: ContentType = .multipart
    var parameter: [String : Any]?
    var items: [Media]?

    init(id: Int, parameter: [String : Any]?, items: [Media]?) {
        self.url = APIURL.patch.description + "\(id)"
        self.parameter = parameter
        self.items = items
    }
}

struct DeleteAPI: Requestable {
    var url: String
    var method: APIMethod = .delete
    var contentType: ContentType = .json
    var deleteItemData: DeleteItemData
    
    init(id: Int, password: String) {
        self.url = APIURL.delete.description + "\(id)"
        self.deleteItemData = DeleteItemData(password: password)
    }
}
