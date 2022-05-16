//
//  TestAPIModel.swift
//  NetworkHandlerTest
//
//  Created by 두기, minseong on 2022/05/16.
//

@testable import OpenMarket

struct TestAPIModel: APIable {
    let host: String
    let path: String
    let params: [String : String]? 
    let method: HttpMethod
}
