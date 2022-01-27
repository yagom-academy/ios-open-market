import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class APIService {
    private let session: URLSessionProtocol
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
        
    private func dataTask(request: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.invalidRequest))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                      completion(.failure(.invalidResponse))
                      return
                  }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(data))
        }
        
        return task
    }
}

// MARK: - OpenMarket APIs

extension APIService {
    func retrieveProductDetail(productId: Int, completion: @escaping (Result<ProductDetail, APIError>) -> Void) {
        guard let url = URLCreator.productDetail(id: productId).url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request = URLRequest(url: url, api: .productDetail)
        
        let task = dataTask(request: request) { result in
            switch result {
            case .success(let data):
                guard let productDetail = try? self.decoder.decode(ProductDetail.self, from: data) else {
                    return
                }
                completion(.success(productDetail))
            case .failure(let error):
                completion(.failure(error))
            }
        }
            
        task.resume()
    }
    
    func retrieveProductList(pageNo: Int, itemsPerPage: Int, completion: @escaping (Result<ProductList, APIError>) -> Void) {
        guard let url = URLCreator.productList(pageNo: pageNo, itemsPerPage: itemsPerPage).url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request = URLRequest(url: url, api: .productList)
        
        let task = dataTask(request: request) { result in
            switch result {
            case .success(let data):
                guard let productList = try? self.decoder.decode(ProductList.self, from: data) else {
                    return
                }
                completion(.success(productList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
            
        task.resume()
    }
    
    func retrieveProductSecret(productId: Int, password: ProductPassword, completion: @escaping (Result<String, APIError>) -> Void) {
        guard let url = URLCreator.productSecret(id: productId).url else {
            return
        }
        
        guard let body = try? JSONEncoder().encode(password) else {
            return
        }
        
        var request = URLRequest(url: url, api: .productSecret(body: body, id: VendorInformation.vendorId))
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = dataTask(request: request) { result in
            switch result {
            case .success(let data):
                if let convertedData = String(data: data, encoding: .utf8) {
                    completion(.success(convertedData))
                }
            case .failure(let error):
                print(error)
            }
        }
        
        task.resume()
    }
    
    func registerProduct(newProduct: ProductRegisterInformation, images: [ImageData], completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = URLCreator.productRegister.url else {
            return
        }
        
        let boundary = generateBoundary()
        
        guard let body = createBody(productRegisterInformation: newProduct, images: images, boundary: boundary) else {
            return
        }
        
        var request = URLRequest(url: url, api: .productRegister(body: body, id: VendorInformation.vendorId))
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let task = dataTask(request: request, completion: completion)
        
        task.resume()
    }
    
    func updateProduct(productId: Int, modifiedProduct: ProductRegisterInformation, completion: @escaping (Result<ProductDetail, APIError>) -> Void) {
        guard let url = URLCreator.productUpdate(id: productId).url else {
            return
        }
        
        guard let body = try? JSONEncoder().encode(modifiedProduct) else {
            return
        }
        
        let request = URLRequest(url: url, api: .productUpdate(body: body, id: VendorInformation.vendorId))
        
        let task = dataTask(request: request) { result in
            switch result {
            case .success(let data):
                guard let productDetail = try? self.decoder.decode(ProductDetail.self, from: data) else {
                    return
                }
                completion(.success(productDetail))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func deleteProduct(productId: Int, secret: String, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = URLCreator.deleteProduct(id: productId, secret: secret).url else {
            return
        }
        
        let request = URLRequest(url: url, api: .deleteProduct(id: VendorInformation.vendorId))
        
        let task = dataTask(request: request, completion: completion)
        
        task.resume()
    }
}

// MARK: - Create Request Body

private extension APIService {
    func generateBoundary() -> String {
        return "\(UUID().uuidString)"
    }
    
    func createBody(productRegisterInformation: ProductRegisterInformation, images: [ImageData], boundary: String) -> Data? {
        var body: Data = Data()
        
        guard let jsonData = try? JSONEncoder().encode(productRegisterInformation) else {
            return nil
        }
        
        body.append(convertDataToMultiPartForm(value: jsonData, boundary: boundary))
        
        images.forEach { image in
            body.append(convertFileToMultiPartForm(imageData: image, boundary: boundary))
        }
        
        body.appendString("--\(boundary)--\r\n")
        return body
    }

    func convertDataToMultiPartForm(value: Data, boundary: String) -> Data {
        var data: Data = Data()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"params\"\r\n")
        data.appendString("Content-Type: application/json\r\n")
        data.appendString("\r\n")
        data.append(value)
        data.appendString("\r\n")

        return data
    }
    
    func convertFileToMultiPartForm(imageData: ImageData, boundary: String) -> Data {
        var data: Data = Data()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"\(imageData.fileName)\"\r\n")
        data.appendString("Content-Type: image/\(imageData.type.description)\r\n")
        data.appendString("\r\n")
        data.append(imageData.data)
        data.appendString("\r\n")
        
        return data
    }
}

private extension Data {
    mutating func appendString(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            return
        }
        self.append(data)
    }
}
