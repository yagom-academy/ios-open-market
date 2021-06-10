//
//  JokesAPIProvider.swift
//  OpenMarket
//
//  Created by kio on 2021/06/10.
//

import Foundation

class JokesAPIProvider {

    let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchRandomJoke(completion: @escaping (Result<ItemDetail, Error>) -> Void) {
        let request = URLRequest(url: Network.firstPage.url)

        let task: URLSessionDataTask = session
            .dataTask(with: request) { data, urlResponse, error in
                guard let response = urlResponse as? HTTPURLResponse,
                      (200...399).contains(response.statusCode) else {
                    completion(.failure(error ?? APIError.unknownError))
                    return
                }

                if let data = data,
                    let jokeResponse = try? JSONDecoder().decode(JokeReponse.self, from: data) {
                    completion(.success(jokeResponse.value))
                    return
                }
                completion(.failure(APIError.unknownError))
        }
        task.resume()
    }
}
