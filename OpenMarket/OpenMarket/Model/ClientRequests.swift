//
//  APIInformations.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/05/28.
//

import Foundation

enum HTTPMethod: String{
    case 목록조회, 상품조회 = "GET"
    case 상품등록 = "POST"
    case 상품수정 = "PATCH"
    case 상품삭제 = "DELETE"
}

struct GETRequest: GetRequestable {
    var urlRequest: URLRequest = URLRequest(url: URL(string: "placeHolder")!)
    let baseURLWithString: String = "https://camp-open-market-2.herokuapp.com/"
    let httpMethod: HTTPMethod

    init(page: Int, descriptionAboutMenu: HTTPMethod){
        self.httpMethod = descriptionAboutMenu
        makeURLRequest(page: page, by: descriptionAboutMenu)
    }
}

//TODO: Step3 에서 구현 예정
struct NonGetRequest: NonGetRequestable {
    var urlRequest: URLRequest
    var baseURLWithString: String
    var httpMethod: HTTPMethod
}
