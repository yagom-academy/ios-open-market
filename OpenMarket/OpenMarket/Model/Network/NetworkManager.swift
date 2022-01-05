//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/04.
//

import UIKit

struct NetworkManager {
    let network: Networkable
    let parser: Parserable
    var baseBoundary: String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    init(network: Networkable = Network(), parser: Parserable = Parser()) {
        self.network = network
        self.parser = parser
    }
    
    func fetch<T: Decodable>(request: URLRequest,
                            decodingType: T.Type,
                            completion: @escaping (Result<T, Error>) -> Void) {
        
        network.execute(request: request) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                let parsingResult = parser.decode(source: data, decodingType: decodingType)
                
                switch parsingResult {
                case .success(let jsonDecode):
                    completion(.success(jsonDecode))
                case .failure:
                    completion(.failure(ParserError.decoding))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // GET - 상품 리스트 조회
    func request(page: UInt, itemsPerPage: UInt) -> URLRequest? {
        guard let url = NetworkConstant.products(page: page, itemsPerPage: itemsPerPage).url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    // GET - 상품 상세 조회
    func request(id: UInt) -> URLRequest? {
        guard let url = NetworkConstant.product(id: id).url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    // POST - 상품 삭제 Secret 상세 조회
    func request<T: Encodable>(data: T, id: UInt, secret: String) -> Result<URLRequest?, Error> {
        guard let url = NetworkConstant.secret(id: id, secret: secret).url else {
            return .failure(NetworkError.notFoundURL)
        }
        let encodingResult = parser.encode(object: data)
        let encodeData: Data
        
        switch encodingResult {
        case .success(let data):
            encodeData = data
        case .failure:
            return .failure(ParserError.encoding)
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = NetworkConstant.HTTPMethod.post.rawValue
        request.httpBody = encodeData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("80c47530-58bb-11ec-bf7f-d188f1cd5f22", forHTTPHeaderField: "identifier")
        
        return .success(request)
    }
    
    // DELET - 상품 삭제
    func request(id: UInt, secret: String) -> URLRequest? {
        guard let url = NetworkConstant.delete(id: id, secret: secret).url else {
            return nil
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = NetworkConstant.HTTPMethod.delete.rawValue
        request.addValue("80c47530-58bb-11ec-bf7f-d188f1cd5f22", forHTTPHeaderField: "identifier")
        
        return request
    }
    
    // PATCH - 상품 수정
    func request<T: Encodable>(data: T, id: UInt) -> Result<URLRequest?, Error> {
        guard let url = NetworkConstant.product(id: id).url else {
            return .failure(NetworkError.notFoundURL)
        }
        let encodingResult = parser.encode(object: data)
        let encodeData: Data
        
        switch encodingResult {
        case .success(let data):
            encodeData = data
        case .failure:
            return .failure(ParserError.encoding)
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = NetworkConstant.HTTPMethod.patch.rawValue
        request.httpBody = encodeData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("80c47530-58bb-11ec-bf7f-d188f1cd5f22", forHTTPHeaderField: "identifier")

        return .success(request)
    }
    
    // POST - 상품 등록
    func request<T: MultipartForm>(params: T, images: [ImageFile]) -> Result<URLRequest?, Error> {
        guard let url = NetworkConstant.register.url else {
            return .failure(NetworkError.notFoundURL)
        }
        let request = multipartFormRequest(url: url, params: params, images: images)
        return .success(request)
    }
    
}

extension NetworkManager {
    private func multipartFormRequest<T: MultipartForm>(url: URL, params: T, images: [ImageFile]) -> URLRequest {
        let encodeBody = createBody(parameters: params.dictionary, images: images, boundary: self.baseBoundary)
        var request = URLRequest(url: url)
        
        request.httpMethod = NetworkConstant.HTTPMethod.post.rawValue
        request.httpBody = encodeBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("80c47530-58bb-11ec-bf7f-d188f1cd5f22", forHTTPHeaderField: "identifier")
        
        return request
    }
    
    private func createBody(parameters: [String: Any?], images: [ImageFile], boundary: String) -> Data {
        var body = Data()
        for (key, value) in parameters {
            if let value = value {
                body.append(convertedMultiPartForm(name: key, value: value, boundary: boundary))
            } else {
                continue
            }
        }
        for image in images {
            body.append(convertedMultiPartForm(image: image, boundary: boundary))
        }
        return body
    }
    
    private func convertedMultiPartForm(name: String, value: Any, boundary: String) -> Data {
        var data = Data()
        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
        data.append("\(value)\r\n")
        return data
    }
    
    private func convertedMultiPartForm(image: ImageFile, boundary: String) -> Data {
        var data = Data()
        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition: form-data; name=\"images[]\"; filename=\"\(image.name)\"\r\n")
        data.append("Content-Type: \(image.type.description)\r\n\r\n")
        data.append("\(image.data)\r\n")
        return data
    }
    
}
