//
//  MarketNetwork.swift
//  OpenMarket
//
//  Created by 윤재웅 on 2021/05/17.
//

import Foundation

protocol MarketNetwork {
    func excuteNetwork(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void)
}


