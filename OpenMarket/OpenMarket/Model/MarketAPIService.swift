//
//  MarketAPIService.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/01/05.
//

import Foundation

struct MarketAPIService {
    private let session: DataTaskProvidable
    
    init(session: DataTaskProvidable = URLSession.shared) {
        self.session = session
    }
}

//MARK: - Nested Types

extension MarketAPIService {
    private enum HTTPMethod {
        static let post = "POST"
        static let get = "GET"
        static let patch = "PATCH"
        static let delete = "DELETE"
    }
    
    private enum MarketAPI {
        static let baseURL = "https://market-training.yagom-academy.kr"
        static let path = "/api/products/"
        
        case postProduct
        case patchProduct(id: Int)
        case postSecret(id: Int)
        case delete(id: Int, secret: String)
        case getProduct(id: Int)
        case getPage(pageNumber: Int, itemsPerPage: Int)
        
        var url: URL? {
            switch self {
            case .postProduct:
                return URL(string: MarketAPI.baseURL + MarketAPI.path)
            case .patchProduct(let id):
                return URL(string: MarketAPI.baseURL + MarketAPI.path + id.stringFormat)
            case .postSecret(let id):
                return URL(string: MarketAPI.baseURL + MarketAPI.path + id.stringFormat + "/secret")
            case .delete(let id, let secret):
                return URL(string: MarketAPI.baseURL + MarketAPI.path + id.stringFormat + "/" + secret)
            case .getProduct(let id):
                return URL(string: MarketAPI.baseURL + MarketAPI.path + id.stringFormat)
            case .getPage(let id, let itemsPerPage):
                guard var urlComponents = URLComponents(string: MarketAPI.baseURL + MarketAPI.path) else {
                    return nil
                }
                let pageNumberQuery = URLQueryItem(name: "page_no", value: id.stringFormat)
                let itemsPerPageQuery = URLQueryItem(name: "items_per_page", value: itemsPerPage.stringFormat)
                
                urlComponents.queryItems = [pageNumberQuery, itemsPerPageQuery]
                
                return urlComponents.url
            }
        }
    }
}

//MARK: - APIServiceable 프로토콜 채택

extension MarketAPIService: APIServicable {
    func registerProduct(
        product: PostProduct,
        images: [ProductImage],
        completionHandler: @escaping (Result<Product, APIError>) -> Void
    ) {
        guard let url = MarketAPI.postProduct.url,
              let jsonData = encode(with: product) else {
            return
        }
        let boundary = UUID().uuidString
        let headers: [String: String] = [
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "identifier": "cd706a3e-66db-11ec-9626-796401f2341a"
        ]
        let body = makeBody(jsonData: jsonData, images: images, boundary: boundary)
        let request = makeRequest(url: url, httpMethod: HTTPMethod.post, headers: headers, body: body)
        
        performDataTask(request: request, completionHandler: completionHandler)
    }
    
    func updateProduct(
        productID: Int,
        product: PatchProduct,
        completionHandler: @escaping (Result<Product, APIError>) -> Void
    ) {
        guard let url = MarketAPI.patchProduct(id: productID).url,
              let body = encode(with: product) else {
                  return
              }
        let headers = ["identifier": "cd706a3e-66db-11ec-9626-796401f2341a"]
        let request = makeRequest(url: url, httpMethod: HTTPMethod.patch, headers: headers, body: body)
        
        performDataTask(request: request, completionHandler: completionHandler)
    }
        
    func getSecret(
        productID: Int,
        password: Password,
        completionHandler: @escaping (Result<String, APIError>) -> Void
    ) {
        guard let url = MarketAPI.postSecret(id: productID).url,
              let body = encode(with: password) else {
                  return
              }
        let headers = ["identifier": "cd706a3e-66db-11ec-9626-796401f2341a",
                       "Content-Type": "application/json"]
        let request = makeRequest(
            url: url,
            httpMethod: HTTPMethod.post,
            headers: headers,
            body: body
        )
        performDataTask(request: request, completionHandler: completionHandler)
    }
    
    func deleteProduct(
        productID: Int,
        productSecret: String,
        completionHandler: @escaping (Result<ProductDetails, APIError>) -> Void
    ) {
        guard let url = MarketAPI.delete(id: productID, secret: productSecret).url else {
            return
        }
        let headers = ["identifier": "cd706a3e-66db-11ec-9626-796401f2341a"]
        let request = makeRequest(
            url: url,
            httpMethod: HTTPMethod.delete,
            headers: headers, body: nil
        )
        performDataTask(request: request, completionHandler: completionHandler)
    }
    
    func fetchProduct(
        productID: Int,
        completionHandler: @escaping (Result<ProductDetails, APIError>) -> Void
    ) {
        guard let url = MarketAPI.getProduct(id: productID).url else {
            return
        }
        let request = URLRequest(url: url)
        performDataTask(request: request, completionHandler: completionHandler)
    }
    
    func fetchPage(
        pageNumber: Int,
        itemsPerPage: Int,
        completionHandler: @escaping (Result<Page, APIError>) -> Void
    ) {
        guard let url = MarketAPI.getPage(pageNumber: pageNumber, itemsPerPage: itemsPerPage).url else {
            return
        }
        let request = URLRequest(url: url)
        performDataTask(request: request, completionHandler: completionHandler)
    }
}

//MARK: - MarketAPIService 메서드

extension MarketAPIService {
    private func makeRequest(
        url: URL,
        httpMethod: String,
        headers: [String: String],
        body: Data?
    ) -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod
        headers.forEach { (key, value) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpBody = body
        
        return request
    }
    
    private func makeBody(
        jsonData: Data,
        images: [ProductImage],
        boundary: String
    ) -> Data {
        var body = Data()
        
        let formData = convertFormField(
            fieldName: "params",
            json: jsonData,
            using: boundary
        )
        body.append(formData)
        
        images.forEach { image in
            guard let data =  convertFileData(
                fieldName: "images",
                image: image,
                using: boundary
            ) else {
                return
            }
            body.append(data)
        }
        body.append("--\(boundary)--\r\n")
        
        return body
    }
    
    private func performDataTask<T: Decodable>(
        request: URLRequest,
        completionHandler: @escaping (Result<T, APIError>) -> Void
    ) {
        let successRange = 200..<300
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                      completionHandler(.failure(APIError.invalidResponse))
                      return
                  }
            guard successRange.contains(statusCode) else {
                completionHandler(.failure(APIError.unsuccessfulStatusCode(statusCode: statusCode)))
                return
            }
            guard let data = data else {
                completionHandler(.failure(APIError.noData))
                return
            }
            if T.self == String.self {
                let stringData = String(decoding: data, as: UTF8.self)
                
                completionHandler(.success(stringData as! T))
                return
            }
            guard let parsedData = parse(with: data, type: T.self) else {
                completionHandler(.failure(APIError.noData))
                return
            }
            
            completionHandler(.success(parsedData))
        }
        
        dataTask.resume()
    }
    
    private func convertFormField(
        fieldName: String,
        json: Data,
        using boundary: String
    ) -> Data {
        var data = Data()
        
        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"\r\n")
        
        data.append("Content-Type: application/json\r\n\r\n")
        data.append(json)
        data.append("\r\n")
        
        return data
    }
    
    private func convertFileData(
        fieldName: String,
        image: ProductImage,
        using boundary: String
    ) -> Data? {
        guard let fileData = image.data else {
            return nil
        }
        let fileName = image.fileName
        let mimeType = "image/\(image.type.description)"
        var data = Data()
        
        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(fileName)\"\r\n")
        data.append("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.append("\r\n")
        
        return data
    }
}
