//
//  FetchImage.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/02.
//

import Foundation

struct FetchImage {
    private let task = NetworkTask(dispatcher: NetworkDispatcher())
    
    class FetchImageRequest: Request {
        var path: String
        var method: HTTPMethod = .get
        
        init(imagePath: String) {
            path = imagePath
        }
    }
    
    func getResource(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(error as! Error))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
