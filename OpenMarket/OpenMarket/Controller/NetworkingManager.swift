//
//  NetworkingManager.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/08/20.
//

import Foundation

struct NetworkingManager {
    let session: URLSessionProtocol
    let parsingManager: ParsingManager
    let baseURL: String
    
    init(session: URLSessionProtocol, parsingManager: ParsingManager, baseURL: String) {
        self.session = session
        self.parsingManager = parsingManager
        self.baseURL = baseURL
    }
    
    func request(bundle request: URLRequest, completion: @escaping (Result<ResultArgument, Error>) -> ()) {
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                completion(.failure(error!))
                return
            }
            let parsedData = parsingManager.parse(data, to: ItemBundle.self)
            switch parsedData {
            case .success(let data):
                completion(.success(data as ResultArgument))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}

