//
//  Networkable.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/05.
//

import Foundation

protocol Networkable {
    func execute(request: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void)
}
