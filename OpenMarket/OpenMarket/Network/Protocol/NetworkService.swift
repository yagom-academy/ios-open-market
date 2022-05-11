//
//  NetworkService.swift
//  OpenMarket
//
//  Created by Lingo, Quokka on 2022/05/11.
//

import Foundation

protocol NetworkService {
  func get(
    url urlString: String,
    headers: [String: String]?,
    completion: (Result<Data, Error>) -> Void)
}
