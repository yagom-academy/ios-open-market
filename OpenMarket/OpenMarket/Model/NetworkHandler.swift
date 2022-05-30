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
        
        component?.queryItems = api.params?.compactMap {
            URLQueryItem(name: $0.key, value: $0.value)
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
            for header in api.header {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
            
            request.httpBody = api.data
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
                \"secret\": \"\(components.secret)\",
                \"descriptions\": \"\(components.descriptions)\"
                }
                """.data(using: .utf8)!
        
        return data
    }
    
    func postItem(model: ItemComponents) {
        let boundary = UUID().uuidString
        let headers = ["identifier" : "99051fa9-d1b8-11ec-9676-978c137c9bee",
                       "Content-Type" : "multipart/form-data; boundary=\(boundary)"]
        var data = Data()
        
        guard let itemData = makeData(components: model) else { return }
                
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"params\"\r\n\r\n".data(using: .utf8)!)
        data.append(itemData)
        for (index, image) in model.imageArray.enumerated() {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                        return
                    }
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(index).jpg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpg\r\n\r\n".data(using: .utf8)!)
            data.append(imageData)
        }
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        let itemAPI = PostItemAPI(header: headers, data: data)
        request(api: itemAPI){_ in }
    }
}
