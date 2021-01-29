//
//  NetworkTask.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/01/29.
//

import Foundation

class NetworkTask {
    let dispatcher: NetworkDispatcher
    
    init(dispatcher: NetworkDispatcher) {
        self.dispatcher = dispatcher
    }
    
    func perform<T: Decodable>(request: Request, dataType: T.Type, completion: @escaping(Result<Any, Error>) -> Void) {
        dispatcher.execute(request: request) { result in
            switch result {
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(dataType, from: data as! Data) else {
                    return completion(.failure(OpenMarketError.convertData))
                }
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
