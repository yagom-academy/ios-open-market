//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/04.
//

import UIKit

struct NetworkManager {
    private let network: Networkable
    private let parser: JSONParserable
    private var baseBoundary: String {
        return UUID().uuidString
    }
    private let identifier = "09e0ff33-7216-11ec-abfa-0f7334722ecd"
    
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
    func requestSecretSearch<T: Encodable>(data: T, id: UInt) -> Result<URLRequest, Error> {
        guard let url = APIAddress.secretSearch(id: id).url else {
            return .failure(NetworkError.notFoundURL)
        }
        guard let encodedData = jsonEncode(data: data) else {
            return .failure(ParserError.encodingFail)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = encodedData
        request.addValue(ContentType.json.string, forHTTPHeaderField: ContentType.contentType.string)
        request.addValue(identifier, forHTTPHeaderField: "identifier")
        
        return .success(request)
    }
    
    // DELET - 상품 삭제
    func requestDelete(id: UInt, secret: String) -> URLRequest? {
        guard let url = APIAddress.delete(id: id, secret: secret).url else {
            return nil
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethod.delete.rawValue
        request.addValue(identifier, forHTTPHeaderField: "identifier")
        
        return request
    }
    
    // PATCH - 상품 수정
    func requestModify<T: Encodable>(data: T, id: UInt) -> Result<URLRequest, Error> {
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
        request.addValue(identifier, forHTTPHeaderField: "identifier")

        return .success(request)
    }
    
    // POST - 상품 등록
    func requestRegister<T: Encodable>(params: T, images: [ImageFile]) -> Result<URLRequest, Error> {
        guard let url = APIAddress.register.url else {
            return .failure(NetworkError.notFoundURL)
        }
        let requestResult = requestMultipartForm(url: url, params: params, images: images)
        
        return requestResult
    }
    
}

extension NetworkManager {
    private func requestMultipartForm<T: Encodable>(
        url: URL,
        params: T,
        images: [ImageFile]
    ) -> Result<URLRequest, Error> {
        let boundary = baseBoundary
        var request = URLRequest(url: url)
        let bodyResult = createBody(data: params, images: images, boundary: boundary)
        
        switch bodyResult {
        case .success(let bodyData):
            request.httpBody = bodyData
        case .failure(let error):
            return .failure(error)
        }
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue(identifier, forHTTPHeaderField: "identifier")
        request.addValue(ContentType.formData(boundary: boundary).string,
                         forHTTPHeaderField: ContentType.contentType.string)
    
        return .success(request)
    }
    
    private func createBody<T: Encodable>(data: T, images: [ImageFile], boundary: String) -> Result<Data, Error> {
        var body = Data()
        guard let encodedData = jsonEncode(data: data) else {
            return .failure(ParserError.encodingFail)
        }
        body.append(MultipartForm.boundary(baseBoundary: boundary).string)
        body.append(MultipartForm.paramsDisposition.string)
        body.append(MultipartForm.paramsContentType.string)
        body.append(encodedData)
        body.append(MultipartForm.newline.string)
        
        for image in images {
            body.append(imageMultiPartForm(image: image, boundary: boundary))
        }
        body.append(MultipartForm.lastBoundary(baseBoundary: boundary).string)
        
        return .success(body)
    }
    
    private func imageMultiPartForm(image: ImageFile, boundary: String) -> Data {
        var data = Data()
        let fileName = "\(UUID().uuidString).\(image.type.rawValue)"
        data.append(MultipartForm.boundary(baseBoundary: boundary).string)
        data.append(MultipartForm.imagesDisposition(filename: fileName).string)
        data.append(MultipartForm.imageContentType(imageType: image.type.description).string)
        data.append(image.data)
        data.append(MultipartForm.newline.string)

        return data
    }
    
    private func jsonEncode<T: Encodable>(data: T) -> Data? {
        let encodingResult = parser.encode(object: data)
        let encodedData: Data?
        
        switch encodingResult {
        case .success(let data):
            encodedData = data
        case .failure:
            encodedData = nil
        }
        
        return encodedData
    }
}
