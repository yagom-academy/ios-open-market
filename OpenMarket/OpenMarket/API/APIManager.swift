//
//  APIManager.swift
//  OpenMarket
//
//  Created by 이예원 on 2021/09/04.
//

import Foundation

enum URI: String {
    case baseUrl = "https://camp-open-market-2.herokuapp.com/"
    static let fetchListPath = "\(Self.baseUrl.rawValue)items/"
    static let registerPath = "\(Self.baseUrl.rawValue)item/"
}

class APIManager {
    static let shared = APIManager()
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    func fetchProductList(page: Int, completion: @escaping (Result<Items, APIError>) -> ()) {
        guard let url = URL(string: "\(URI.fetchListPath)\(page)") else { return }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(APIError.requestFailed))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.unknown))
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(Items.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(APIError.emptyData))
                }
            }
        }
        task.resume()
    }
}
