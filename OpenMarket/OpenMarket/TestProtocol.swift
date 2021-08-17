//
//  TestProtocol.swift
//  OpenMarket
//
//  Created by Theo on 2021/08/17.
//

import Foundation

protocol TestProtocol { //채택하고 얘로 의존성 주입을 한다.
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: TestProtocol {
    
}
