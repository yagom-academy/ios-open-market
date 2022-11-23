//  URLSessionable.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/21.

import Foundation

protocol URLSessionable {
    func dataTask(with request: URLRequest, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> URLSessionDataTask
}
