//
//  Requestable.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/02.
//

import Foundation

//MARK: - ClientRequest를 메서드에 따라 구분해서 생성해주어야 하므로 Protocol을 통해 구현했음.
protocol Requestable {
    var urlRequest: URLRequest { get set }
    var baseURLWithString: String { get }
    var httpMethod: HTTPMethod { get }
    
    func makeURL(path: String) -> URL
}

extension Requestable {
    func makeURL(path: String) -> URL {
        return URL(string: baseURLWithString + path)!
    }
}

// MARK:- Get메서드를 사용하는 목록조회, 상품조회의 URLRequest를 생성하기 위한 protocol-extension
protocol GETRequestable: Requestable {
    mutating func makeURLRequest(page: Int, by description: HTTPMethod)
}

extension GETRequestable {
    mutating func makeURLRequest(page: Int, by description: HTTPMethod) {
        switch description {
        case .목록조회:
            urlRequest.url = makeURL(path: "items/\(page)")
            urlRequest.httpMethod = httpMethod.rawValue
        case .상품조회:
            urlRequest.httpMethod = httpMethod.rawValue
        default:
            return
        }
    }
}

// MARK:- Get 이외의 메서드를 사용하는 목록조회, 상품조회의 URLRequest를 생성하기 위한 protocol-extension
// TODO:- 기능요구서 상 Step3에서 구현 예정, frame만 만들어둔 상태.
protocol NonGetRequestable: Requestable {
    mutating func makeURLRequest(page: Int, by description: HTTPMethod)
}

extension NonGetRequestable {
    mutating func makeURLRequest(page: Int, by description: HTTPMethod) {
        switch description {
        case .상품등록:
            urlRequest.httpMethod = httpMethod.rawValue
        case .상품삭제:
            urlRequest.httpMethod = httpMethod.rawValue
        case .상품수정:
            urlRequest.httpMethod = httpMethod.rawValue
        default:
            return
        }
    }
}
