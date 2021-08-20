//
//  MockAPIManager.swift
//  OpenMarket
//
//  Created by Charlotte, Hosinging on 2021/08/10.
//

import UIKit

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

enum URI: String {
    case baseUrl = "https://camp-open-market-2.herokuapp.com/"
    static let registerPath = "\(Self.baseUrl.rawValue)item/"
    static let fetchListPath = "\(Self.baseUrl.rawValue)items/"
}

class APIManager {
    static let shared = APIManager()
    
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchProductList(page: Int, completion: @escaping (Result<ProductListSearch, APIError>) ->()) {
        guard let url = URL(string: "\(URI.fetchListPath)\(page)") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return
            }
            if let data = data {
                
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(ProductListSearch.self, from: data)
                    completion(.success(result))
                    
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(APIError.invalidURL))
                }
            }
        }
        task.resume()
    }
    
    func registProduct(parameters: [String : Any], media: [Media], completion: @escaping (Result<Data, APIError>) -> ()) {
        guard let url = URL(string: URI.registerPath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = MultiPartForm.boundary
        let contentDispostion = MultiPartForm.contentDisposition
        request.setValue(MultiPartForm.httpHeader.description, forHTTPHeaderField: MultiPartForm.httpHeaderField.description)
        let httpBody = MultiPartForm.creatHTTPBody(parameters: parameters, media: media, boundary: boundary, contentDisposition: contentDispostion)
        request.httpBody = httpBody
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data {
                do {
                    let product = try JSONEncoder().encode(data)
                    completion(.success(product))
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
