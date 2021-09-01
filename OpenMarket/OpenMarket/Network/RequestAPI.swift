//
//  RequestAPI.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/31.
//

import UIKit

struct GetItemAPI: Requestable {
    var url: String
    var method: APIMethod = .get
    var contentType: ContentType = .json
    
    init(id: Int) {
        self.url = APIURL.getItem.description + "\(id)"
    }
}

struct GetItemsAPI: Requestable {
    var url: String
    var method: APIMethod = .get
    var contentType: ContentType = .json
    
    init(page: Int) {
        self.url = APIURL.getItems.description + "\(page)"
    }
}

struct PostAPI: RequestableWithMultipartForm {
    var url: String = APIURL.post.description
    var method: APIMethod = .post
    var contentType: ContentType = .multipart
    var parameter: [String : Any]
    var image: [imageData]?
    
    init(parameter: [String: Any], image: [imageData]) {
        self.parameter = parameter
        self.image = image
    }
}

struct PatchAPI: RequestableWithMultipartForm {
    var url: String
    var method: APIMethod = .patch
    var contentType: ContentType = .multipart
    var parameter: [String: Any]
    var image: [imageData]?
    
    init(id: Int, parameter: [String: Any], image: [imageData]?) {
        self.url = APIURL.patch.description + "\(id)"
        self.parameter = parameter
        self.image = image
    }
}

struct DeleteAPI: Requestable {
    var url: String
    var method: APIMethod = .delete
    var contentType: ContentType = .json
    var password: DeleteParameterData
    
    init(id: Int, password: String) {
        self.url = APIURL.delete.description + "\(id)"
        self.password = DeleteParameterData(password: password)
    }
}

