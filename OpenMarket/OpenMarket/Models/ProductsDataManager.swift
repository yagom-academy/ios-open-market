import UIKit.NSDataAsset

struct ProductsDataManager: Decodable {
    static let shared = ProductsDataManager()
    private init() {}
    
    var url = "https://market-training.yagom-academy.kr/api/products"
    
    func getData<T: Decodable>(pageNumber: Int, itemsPerPage: Int, completion: @escaping (T) -> Void) {
        
        var urlComponent = URLComponents(string: url)
        urlComponent?.queryItems = [
            URLQueryItem(name: "page_no", value: String(pageNumber)),
            URLQueryItem(name: "items_per_page", value: String(itemsPerPage))
        ]
        
        guard let urlComponentURL = urlComponent?.url else { return }
        let request = URLRequest(url: urlComponentURL)
        
        sendRequest(request, completion)
    }
    
    func getData<T: Decodable>(productId: Int, completion: @escaping (T) -> Void) {
        guard let  urlComponent = URL(string: "\(url)/\(productId)") else { return }
        let request = URLRequest(url: urlComponent)
        
        sendRequest(request, completion)
    }
    
    func postData<T: Decodable>(identifier: String, paramter: Parameters, images: [UIImage], completion: @escaping (T) -> Void) {
        guard let url = URL(string: url) else { return }
        var postRequest = URLRequest(url: url)
        
        let boundary = generateBoundary()
        
        postRequest.httpMethod = "POST"
        postRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        postRequest.addValue(identifier, forHTTPHeaderField: "identifier")
        
        var convertedImages: [ImageInfo] = []
        images.forEach {
            if let convertedImage = ImageInfo(withImage: $0) {
                convertedImages.append(convertedImage)
            }
        }
        
        let dataBody = createDataBody(withParameters: paramter, images: convertedImages, boundary: boundary)
        postRequest.httpBody = dataBody
        
        let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(decodedData)
                } catch {
                }
            }
        }
        task.resume()
    }
    
    func getProductSecret(identifier: String, secret: String, productId: Int, completion: @escaping (Result<String, IdentifierError>) -> Void) {
        guard let url = URL(string: url + "/" + String(productId) + "/secret") else { return }
        var postRequest = URLRequest(url: url)
        
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        postRequest.addValue(identifier, forHTTPHeaderField: "identifier")
        
        postRequest.httpBody = Parameters(secret: secret).returnParamatersToJsonData()

        let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            if let data = data {
                if let parsedData = String(data: data, encoding: .utf8) {
                    completion(.success(parsedData))
                } else {
                    completion(.failure(.notYourProduct))
                }
            }
        }
        task.resume()
    }
    
    func patchData<T: Decodable>(identifier: String, productID: Int, paramter: Parameters, completion: @escaping (Result<T, IdentifierError>) -> Void) {
        guard let url = URL(string: url + "/\(productID)") else { return }
        var postRequest = URLRequest(url: url)
        
        postRequest.httpMethod = "PATCH"
        postRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        postRequest.addValue(identifier, forHTTPHeaderField: "identifier")
        postRequest.httpBody = paramter.returnParamatersToJsonData()
        
        let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let parsedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(parsedData))
                } catch {
                    completion(.failure(.notYourProduct))
                }
            }
        }
        task.resume()
    }
    
    func deleteData<T: Decodable>(identifier: String, productID: Int, secret: String, completion: @escaping (Result<T, IdentifierError>) -> Void) {
        guard let url = URL(string: "\(url)/\(productID)/\(secret)") else {
            completion(.failure(.notYourProduct))
            return
        }
        
        var postRequest = URLRequest(url: url)
        
        postRequest.httpMethod = "DELETE"
        postRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        postRequest.addValue(identifier, forHTTPHeaderField: "identifier")
        
        let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            guard response != nil else {
                completion(.failure(.notYourProduct))
                return
            }
            
            if let data = data {
                do {
                    let parsedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(parsedData))
                } catch {
                    completion(.failure(.notYourProduct))
                }
            }
        }
        task.resume()
    }
    
    private func sendRequest<T: Decodable>(_ request: URLRequest, _ completion: @escaping (T) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            do {
                let data = try checkValidData(data, response, error)
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(decodedData)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    private func checkValidData(_ data: Data?, _ response: URLResponse?, _ error: Error?) throws -> Data {
        if let error = error {
            throw error
        }
        
        if let urlError = responseErrorhandling(response) {
            throw urlError
        }
        
        guard let data = data else {
            throw URLSessionError.invalidData
        }
        
        return data
    }
    
    private func responseErrorhandling(_ response: URLResponse?) -> URLSessionError? {
        guard let response = response as? HTTPURLResponse else { return nil }
        switch response.statusCode {
        case 300..<400:
            return URLSessionError.redirection
        case 400..<500:
            return URLSessionError.clientError
        case 500..<600:
            return URLSessionError.serverError
        default:
            return nil
        }
    }
    
    // MARK: - generateBoundary

    private func generateBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }

    // MARK: - createDataBody

    private func createDataBody(withParameters params: Parameters, images: [ImageInfo]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        do {
            try body.append("--\(boundary + lineBreak)")
            try body.append("Content-Disposition: form-data; name=\"\(Parameters.key)\"\(lineBreak + lineBreak)")
            try body.append(params.returnParamatersToJsonData())
            try body.append("\(lineBreak)")
            
            if let images = images {
                for image in images {
                    try body.append("--\(boundary + lineBreak)")
                    try body.append("Content-Disposition: form-data; name=\"\(ImageInfo.key)\"; filename=\"\(image.filename)\"\(lineBreak)")
                    try body.append("Content-Type: \(image.mimeType + lineBreak + lineBreak)")
                    try body.append(image.getReducedImageData(to: 300))
                    try body.append(lineBreak)
                }
            }
            
            try body.append("--\(boundary)--\(lineBreak)")
        } catch {
            print(error)
        }
        return body
    }
}
