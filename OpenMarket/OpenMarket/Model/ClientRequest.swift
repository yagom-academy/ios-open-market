//
//  APIInformations.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/05/28.
//

import Foundation

enum DescriptionAboutMenu: String {
    case 목록조회, 상품조회 = "GET"
    case 상품등록 = "POST"
    case 상품수정 = "PATCH"
    case 상품삭제 = "DELETE"
}

struct Header {
    let url: URL
    let method: String
    let contentsType: String
}

struct Body {
    let item: Item
}

struct ClientRequest {
    var header: Header?
    var body: Body?
    let baseURLWithString: String = "https://camp-open-market-2.herokuapp.com/"
    var page: Int?
    var path: String = ""
    let contentType: String = ""
    let descriptionAboutMenu: DescriptionAboutMenu
    
    init(page: Int, descriptionAboutMenu: DescriptionAboutMenu){
        self.page = page
        self.descriptionAboutMenu = descriptionAboutMenu
        setProperty(by: descriptionAboutMenu)
    }
    
    mutating func setProperty(by description: DescriptionAboutMenu){
        switch description {
        case .목록조회:
            if let page = page { path = "items/:\(page)" }
            header = Header(url: URL(string: baseURLWithString + path)!, method: description.rawValue, contentsType: "application/json")
            body = nil
        case .상품등록:
            path = "item"
            header = Header(url: URL(string: baseURLWithString + path)!, method: description.rawValue, contentsType: "multipart/form-data")
            body = nil
        case .상품조회:
            if let body = body { path = "item/:\(body.item.id)" }
            header = Header(url: URL(string: baseURLWithString + path)!, method: description.rawValue, contentsType: "multipart/form-data")
            body = nil
        case .상품수정:
            if let body = body { path = "item/:\(body.item.id)"}
            header = Header(url: URL(string: baseURLWithString + path)!, method: description.rawValue, contentsType: "multipart/form-data")
            body = nil
        case .상품삭제:
            if let body = body { path = "item/:\(body.item.id)"}
            header = Header(url: URL(string: baseURLWithString + path)!, method: description.rawValue, contentsType: "application/json")
            body = nil
        }
    }
}
