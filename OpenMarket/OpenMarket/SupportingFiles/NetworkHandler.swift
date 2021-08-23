//
//  NetworkHandler.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/17.
//

import Foundation

protocol Sessionable {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: Sessionable { }

struct NetworkHandler {
    private let session: Sessionable
    private let valuableMethod: [HttpMethod]
    
    init(session: Sessionable = URLSession.shared, valuableMethod: [HttpMethod] = HttpMethod.allCases) {
        self.session = session
        self.valuableMethod = valuableMethod
    }
    
    func request(api: OpenMarketAPI, form: DataForm? = nil, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard valuableMethod.contains(api.request.method),
            let url = URL(string: api.request.url)
        else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = String(describing: api.request.method)
        request.httpBody = try? form?.createBody()
        request.setValue(form?.contentType, forHTTPHeaderField: "Content-Type")
        
        session.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else { return }
            if let data = data {
                completionHandler(.success(data))
            }
        }.resume()
    }
}
