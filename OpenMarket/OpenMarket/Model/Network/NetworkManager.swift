//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/04.
//

import UIKit

struct NetworkManager {
    let network: Networkable
    let parser: JSONParserable
    var baseBoundary: String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    init(network: Networkable = Network(), parser: JSONParserable = JSONParser()) {
        self.network = network
        self.parser = parser
    }
    
    func fetch<T: Decodable>(
        request: URLRequest,
        decodingType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
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
                    completion(.failure(ParserError.decodingFail))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // GET - 상품 리스트 조회
    func requestListSearch(page: UInt, itemsPerPage: UInt) -> URLRequest? {
        guard let url = APIAddress.products(page: page, itemsPerPage: itemsPerPage).url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    // GET - 상품 상세 조회
    func requestDetailSearch(id: UInt) -> URLRequest? {
        guard let url = APIAddress.product(id: id).url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    // POST - 상품 삭제 Secret 상세 조회
    func requestSecretSearch<T: Encodable>(data: T, id: UInt, secret: String) -> Result<URLRequest?, Error> {
        guard let url = APIAddress.secretSearch(id: id).url else { // 다른점
            return .failure(NetworkError.notFoundURL)
        }
        guard let encodeData = jsonEncode(data: data) else {
            return .failure(ParserError.encodingFail)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue // 다른점
        request.httpBody = encodeData
        request.addValue(ContentType.json.string, forHTTPHeaderField: ContentType.contentType.string)
        request.addValue("80c47530-58bb-11ec-bf7f-d188f1cd5f22", forHTTPHeaderField: "identifier")
        
        return .success(request)
    }
    
    // DELET - 상품 삭제
    func requestDelete(id: UInt, secret: String) -> URLRequest? {
        guard let url = APIAddress.delete(id: id, secret: secret).url else {
            return nil
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethod.delete.rawValue
        request.addValue("80c47530-58bb-11ec-bf7f-d188f1cd5f22", forHTTPHeaderField: "identifier")
        
        return request
    }
    
    // PATCH - 상품 수정
    func requestModify<T: Encodable>(data: T, id: UInt) -> Result<URLRequest?, Error> {
        guard let url = APIAddress.product(id: id).url else {
            return .failure(NetworkError.notFoundURL)
        }
        guard let encodeData = jsonEncode(data: data) else {
            return .failure(ParserError.encodingFail)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.patch.rawValue
        request.httpBody = encodeData
        request.addValue(ContentType.json.string, forHTTPHeaderField: ContentType.contentType.string)
        request.addValue("80c47530-58bb-11ec-bf7f-d188f1cd5f22", forHTTPHeaderField: "identifier")

        return .success(request)
    }
    
    // POST - 상품 등록
    func requestRegister<T: MultipartFormProtocol>(params: T, images: [ImageFile]) -> Result<URLRequest?, Error> {
        guard let url = APIAddress.register.url else {
            return .failure(NetworkError.notFoundURL)
        }
        let request = requestMultipartForm(url: url, params: params, images: images)
        return .success(request)
    }
    
}

extension NetworkManager {
    private func requestMultipartForm<T: MultipartFormProtocol>(
        url: URL,
        params: T,
        images: [ImageFile]
    ) -> URLRequest {
        let boundary = baseBoundary
        let encodeBody = createBody(parameters: params.dictionary, images: images, boundary: boundary)
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(ContentType.formData(boundary: boundary).string,
                         forHTTPHeaderField: ContentType.contentType.string)
        request.addValue("80c47530-58bb-11ec-bf7f-d188f1cd5f22", forHTTPHeaderField: "identifier")
        request.httpBody = encodeBody
        
        return request
    }
    
    private func createBody(parameters: [String: Any?], images: [ImageFile], boundary: String) -> Data {
        var body = Data()
        for (key, value) in parameters {
            if let value = value {
                body.append(jsonMultiPartForm(name: key, value: value, boundary: boundary))
            } else {
                continue
            }
        }
        for image in images {
            body.append(imageMultiPartForm(image: image, boundary: boundary))
        }
        body.append(MultipartForm.lastBoundary(baseBoundary: boundary).string)
        
        return body
    }
    
    private func jsonMultiPartForm(name: String, value: Any, boundary: String) -> Data {
        var data = Data()
        data.append(MultipartForm.boundary(baseBoundary: boundary).string)
        data.append(MultipartForm.contentDisposition(name: name).string)
        data.append(MultipartForm.value(value).string)
        return data
    }
    
    private func imageMultiPartForm(image: ImageFile, boundary: String) -> Data {
        var data = Data()
        data.append(MultipartForm.boundary(baseBoundary: boundary).string)
        data.append(MultipartForm.imageContentDisposition(filename: image.name).string)
        data.append(MultipartForm.imageContentType(imageType: image.type.description).string)
        data.append(MultipartForm.imageValue(data: image.data).string)
        return data
    }
    
    private func jsonEncode<T: Encodable>(data: T) -> Data? {
        let encodingResult = parser.encode(object: data)
        let encodeData: Data?
        
        switch encodingResult {
        case .success(let data):
            encodeData = data
        case .failure:
            encodeData = nil
        }
        
        return encodeData
    }
}
