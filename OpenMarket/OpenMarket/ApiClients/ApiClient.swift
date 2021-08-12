//
//  ApiClient.swift
//  OpenMarket
//
//  Created by Jost, 잼킹 on 2021/08/12.
//

import Foundation

class ApiClient: Api, JSONDecodable {
    func getMarketPageItems(for pageNumber: Int,
                            completion: @escaping (Result<MarketItems, Error>) -> Void) {
        let url = "\(Config.baseUrl)/items/\(pageNumber)"
        self.callGetApi(MarketItems.self , url, completion)
    }
    
    func getMarketItem(for id: Int, completion: @escaping (Result<MarketItem, Error>) -> Void) {
        let url = "\(Config.baseUrl)/item/\(id)"
        self.callGetApi(MarketItem.self, url, completion)
    }
}

extension ApiClient {
    private func callGetApi<T: Decodable>(_ type: T.Type,
                               _ url: String,
                               _ completion: @escaping (Result<T, Error>) -> Void) {
        let successRange = 200...299
        
        guard let url = URL(string: url) else {
            completion(.failure(ApiError.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                guard error == nil else {
                    completion(.failure(ApiError.dataTask))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(ApiError.invalidResponse))
                    return
                }
                
                guard successRange.contains(httpResponse.statusCode) else {
                    if let data = data {
                        let parsedError = try self.decodeJSON(ResponseErrorMessage.self, from: data)
                        completion(.failure(ApiError.serverMessage(message: parsedError.message)))
                        return
                    }
                    
                    completion(.failure(ApiError.outOfRange(statusCode: httpResponse.statusCode)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(ApiError.invalideData))
                    return
                }
                
                let parsedData = try self.decodeJSON(T.self, from: data)
                completion(.success(parsedData))
            } catch let parsingError as ParsingError {
                completion(.failure(parsingError))
            } catch {
                completion(.failure(ApiError.unknown))
            }
        }.resume()
    }
}
