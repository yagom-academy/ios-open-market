//
//  MultipartFormImpormation.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/16.
//

import Foundation

struct PostImpormation: Networkable {
    var placeholderList: [String] {
        var array = PostAndPatchParameter.values
        array.removeFirst()
        return array
    }
    var essentialPublicElement: EssentialPublicElement = .post
    var requestAPI: Requestable
    init(parameter: [String: Any], image: [Media]) {
        requestAPI = PostAPI(parameter: parameter, image: image)
    }
}

struct PatchImpormation: Networkable {
    let placeholderList: [String] = PostAndPatchParameter.values
    var essentialPublicElement: EssentialPublicElement = .patch
    var requestAPI: Requestable
    init(id: Int, parameter: [String: Any], image: [Media]) {
        requestAPI = PatchAPI(id: id, parameter: parameter, image: image)
    }
}
