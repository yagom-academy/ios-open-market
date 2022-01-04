//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/04.
//

import Foundation

struct NetworkManager {
    let network: Network
    let parser: Parser
    
    init(network: Network, parser: Parser) {
        self.network = network
        self.parser = parser
    }
    
    func fetch<T: Decodable>(request: URLRequest,
                            decodingType: T.Type,
                            completion: @escaping (Result<T, Error>) -> Void) {
        
        network.execute(request: request) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                let parsingResult = parser.decode(source: data, decodingType: decodingType)
                
                switch parsingResult {
                case .success(let jsonDecode):
                    completion(.success(jsonDecode))
                case .failure:
                    completion(.failure(ParserError.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // GET - 상품 리스트 조회
    func request(page: UInt, itemsPerPage: UInt) -> URLRequest? {
        guard let url = NetworkConstant.products(page: page, itemsPerPage: itemsPerPage).url else {
            return nil
        }
        return URLRequest(url: url)
    }
}
