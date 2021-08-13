//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by JINHONG AN on 2021/08/13.
//

import Foundation

struct NetworkManager {
    private let rangeOfSuccessState = 200...299
    private let baseURL = "https://camp-open-market-2.herokuapp.com/"
    
    func lookUpList(on pageNum: Int, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let searchURL = baseURL + "/items/\(pageNum)"
        guard let url = URL(string: searchURL) else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let response = response as? HTTPURLResponse, rangeOfSuccessState.contains(response.statusCode), let data = data {
                DispatchQueue.main.async {
                    completionHandler(.success(data))
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            }
        }.resume()
    }
}
