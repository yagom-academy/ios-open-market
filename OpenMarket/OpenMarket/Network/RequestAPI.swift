//
//  RequestAPI.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/31.
//

import Foundation

struct GetItemsAPI: RequestableWithoutBody {
    var url: APIURL
    var method: APIMethod = .get
    var contentType: ContentType = .json

    init(page: Int) {
        self.url = .getItems(page: page)
    }
}

struct GetItemAPI: RequestableWithoutBody {
    var url: APIURL
    var method: APIMethod = .get
    var contentType: ContentType = .json

    init(id: Int) {
        self.url = .getItem(id: id)
    }
}

struct PostItemAPI: RequestableWithBody {
    var url: APIURL = .post
    var method: APIMethod = .post
    var contentType: ContentType = .multipart
    var parameters: Parameters
    var images: [Media]?

    init(parameters: Parameters, images: [Media]) {
        self.parameters = parameters
        self.images = images
    }
}

struct PatchItemAPI: RequestableWithBody {
    var url: APIURL
    var method: APIMethod = .patch
    var contentType: ContentType = .multipart
    var parameters: Parameters
    var images: [Media]?

    init(id: Int, parameters: Parameters, images: [Media]?) {
        self.url = APIURL.patch(id: id)
        self.parameters = parameters
        self.images = images
    }
}

struct DeleteItemAPI: Requestable {
    var url: APIURL
    var method: APIMethod = .delete
    var contentType: ContentType = .json
    var deleteItem: DELETEItem

    init(id: Int, password: String) {
        self.url = APIURL.delete(id: id)
        self.deleteItem = DELETEItem(password: password)
    }
}
