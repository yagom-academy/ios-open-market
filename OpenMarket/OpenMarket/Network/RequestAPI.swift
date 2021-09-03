//
//  RequestAPI.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/31.
//

import UIKit

struct GetItemAPI: Requestable {
    var url: APIURL
    let httpMethod: APIHTTPMethod = .get
    let contentType: ContentType = .json
    
    init(id: Int) {
        self.url = .getItem(id: id)
    }
}

struct GetItemsAPI: Requestable {
    var url: APIURL
    let httpMethod: APIHTTPMethod = .get
    let contentType: ContentType = .json
    
    init(page: Int) {
        self.url = .getItems(page: page)
    }
}

struct PostAPI: RequestableWithMultipartForm {
    let url: APIURL = .post
    let httpMethod: APIHTTPMethod = .post
    let contentType: ContentType = .multipart
    let parameter: [String: Any]
    var image: [Media]?
    
    init(parameter: [String: Any], image: [Media]) {
        self.parameter = parameter
        self.image = image
    }
}

struct PatchAPI: RequestableWithMultipartForm {
    var url: APIURL
    let httpMethod: APIHTTPMethod = .patch
    let contentType: ContentType = .multipart
    let parameter: [String: Any]
    var image: [Media]?
    
    init(id: Int, parameter: [String: Any], image: [Media]?) {
        self.url = .patch(id: id)
        self.parameter = parameter
        self.image = image
    }
}

struct DeleteAPI: Requestable {
    var url: APIURL
    let httpMethod: APIHTTPMethod = .delete
    let contentType: ContentType = .json
    var password: DeleteParameterData
    
    init(id: Int, password: String) {
        self.url = .delete(id: id)
        self.password = DeleteParameterData(password: password)
    }
}
