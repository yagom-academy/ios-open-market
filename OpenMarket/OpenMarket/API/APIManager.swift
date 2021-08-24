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
    let boundary = "Boundary-\(UUID().uuidString)"
    
    func fetchProductList(page: Int, completion: @escaping (Result<ProductListSearch, APIError>) ->()) {
        guard let url = URL(string: "\(URI.fetchListPath)\(page)") else { return }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
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
    func createHTTPBody(parameters: HTTPBodyParameter?, media: [Media]?) -> Data {
    
        let lineBreak = "\r\n"
        let lastBoundary = "--\(boundary)--\(lineBreak)"
        let contentDisposition = "Content-Disposition: form-data; name="
        let contentType = "Content-Type: "
        
        var body = Data()
        
        if let parameters = parameters {
            for (key,value) in parameters {
                body.append("--\(boundary)\(lineBreak)")
                body.append("\(contentDisposition)\"\(key)\"\(lineBreak)\(lineBreak)")
                body.append("\(value)\(lineBreak)")
            }
        }
        
        if let media = media {
            for image in media {
                body.append("--\(boundary)\(lineBreak)")
                body.append("\(contentDisposition)\"\(image.key)\"; filename=\"\(image.fileName)\"\(lineBreak)")
                body.append("\(contentType) \(image.mimeType)\(lineBreak)\(lineBreak)")
                body.append(image.imageData)
                body.append(lineBreak)
            }
        }
        body.append(lastBoundary)
        return body
    }
    
    func registProduct(parameters: [String : Any], media: [Media], completion: @escaping (Result<Data, APIError>) -> ()) {
        guard let url = URL(string: "https://camp-open-market-2.herokuapp.com/item") else { return }
        var request = URLRequest(url: url)
        
        let httpHeader = "multipart/form-data; boundary=\(boundary)"
        let httpHeaderField = "Content-Type"
        
        request.httpMethod = "post"
        request.setValue(httpHeader, forHTTPHeaderField: httpHeaderField)
        request.httpBody = createHTTPBody(parameters: parameters, media: media)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(APIError.invalidURL))
                return
            }
            
            if let error = error {
                completion(.failure(APIError.emptyData))
            }
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
    }
}
