//
//  JokesAPIProvider.swift
//  OpenMarket
//
//  Created by kio on 2021/06/10.
//

import Foundation

enum APIError: Error {
    case unknownError
}

class MockAPIProvider {
    let session: URLSession
        init(session: URLSession){
                self.session = session
        }

    func fetchRandomJoke(completion: @escaping(Result<ItemDetail, APIError>) -> Void) {
        let request = URLRequest(url: JokesAPI.url)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                completion(.failure(.unknownError))
                return
            }
            
            if let data = data,
               let jokeResponse = try? JSONDecoder().decode(JokeReponse.self, from: data) {
                completion(.success(jokeResponse.value))
                return
            }
            
            completion(.failure(.unknownError))
        }
        task.resume()
    }
}
