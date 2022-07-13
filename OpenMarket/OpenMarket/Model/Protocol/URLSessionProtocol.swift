//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by 케이, 수꿍 on 2022/07/13.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URLAlternativeProtocol, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}
