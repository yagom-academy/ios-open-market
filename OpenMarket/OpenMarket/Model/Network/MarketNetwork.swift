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

protocol DecoderProtocol {
    func decode<T>(_ type: T.Type, from: Data) throws -> T where T : Decodable
}

extension JSONDecoder: DecoderProtocol {
    
}
