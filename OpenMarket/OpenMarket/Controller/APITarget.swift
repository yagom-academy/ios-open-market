//
//  APITarget.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/17.
//

import UIKit

enum APITarget: TargetType {
    var headers: [String : String]? {
        return ["hello": "hello"]
    }
    
    case 목록조회(page: Int)
    case 상품등록
    case 상품조회(id: Int)
    case 상품수정(id: Int)
    case 상품삭제(id: Int)
    
    var baseURL: String {
        return "https://camp-open-market-2.herokuapp.com/"
    }
    
    var path: String {
        switch self {
        case .목록조회(let page):
            return "/items/\(page)"
        case .상품등록:
            return "/item"
        case .상품조회(let id), .상품수정(let id), .상품삭제(let id):
            return "/item/\(id)"
        }
    }
    
    var url: URL {
        return URL(string: baseURL + path)!
    }
    
    var method: HTTPMethod {
        switch self {
        case .목록조회, .상품조회:
            return .GET
        case .상품등록:
            return .POST
        case .상품수정:
            return .PATCH
        case .상품삭제:
            return .DELETE
        }
    }
    
    var sampleData: Data {
        return NSDataAsset(name: "Item")!.data
    }
    
    var request: URLRequest {
        switch self {
        case .목록조회:
            return URLRequest(url: url)
        default:
            //아직 미구현
            return URLRequest(url: url)
        }
    }
}
