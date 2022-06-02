//
//  URLSeesion.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/10.
//

import Foundation

struct NetworkHandler {
    private let session: URLSessionProtocol
    private let baseURL = "https://market-training.yagom-academy.kr/"
    
    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }
    
    private func makeURL(api: APIable) -> URL? {
        var component = URLComponents(string: api.host + api.path)
        
        if api.method == .get {
            component?.queryItems = api.params?.compactMap {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        return component?.url
    }
    
    func request(api: APIable, response: @escaping (Result<Data?, APIError>) -> Void) {
        guard let url = makeURL(api: api) else {
            return response(.failure(.convertError))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = api.method.string
        
        if api.method == .post {
            guard let urlRequest = makePostData(api: api, urlRequest: request) else { return }
            request = urlRequest
        }
        
        if api.method == .delete {
            request.addValue("99051fa9-d1b8-11ec-9676-978c137c9bee", forHTTPHeaderField: "identifier")
        }
        
        session.receiveResponse(request: request) { responseResult in
            guard responseResult.error == nil else {
                return response(.failure(.transportError))
            }
            
            guard let statusCode = (responseResult.response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                return response(.failure(.responseError))
            }
            response(.success(responseResult.data))
        }
    }
    
    private func makeData(components: ItemComponents) -> Data? {
        let data = """
                {
                \"name\": \"\(components.name)\",
                \"price\": \(components.price),
                \"currency\": \"\(components.currency)\",
                \"discounted_price\": \(components.discountedPrice),
                \"stock\": \(components.stock),
                \"secret\": \"zsxn8cy106\",
                \"descriptions\": \"\(components.descriptions)\"
                }
                """.data(using: .utf8)!
        
        return data
    }
    
    private func makePostData(api: APIable, urlRequest: URLRequest) -> URLRequest? {
        let boundary = UUID().uuidString
        var request = urlRequest
        
        request.addValue("99051fa9-d1b8-11ec-9676-978c137c9bee", forHTTPHeaderField: "identifier")
        
        var data = Data()
        
        if let model = api.itemComponents {
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            guard let itemData = makeData(components: model) else { return nil }
                    
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"params\"\r\n\r\n".data(using: .utf8)!)
            data.append(itemData)
            for (index, image) in model.imageArray.enumerated() {
                guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                            return nil
                        }
                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(index).jpg\"\r\n".data(using: .utf8)!)
                data.append("Content-Type: image/jpg\r\n\r\n".data(using: .utf8)!)
                data.append(imageData)
            }
            
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = data
            return request
        }
        
        guard let password = api.password else { return nil }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let secretData = "{\"secret\": \"\(password)\"}".data(using: .utf8) else { return nil }

        request.httpBody = secretData
        
        return request
        
    }
}
