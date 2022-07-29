import UIKit

struct ImageInfo {
    static let key: String = "images"
    
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage) {
        self.mimeType = "image/jpeg"
        self.filename = "image\(arc4random()).jpeg"
        
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}

struct Parameters {
    static let key: String = "params"
    
    let name: String
    let descriptions: String
    let price: Int
    let currency: Currency
    let discountedPrice: Int?
    let stock: Int?
    let secret: String
    
    init(name: String, descriptions: String, price: Int, currency: Currency, secret: String, discounted_price: Int? = 0, stock: Int? = 0) {
        self.name = name
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.discountedPrice = discounted_price
        self.stock = stock
        self.secret = secret
    }
    
    func returnParamatersString() -> String {
        var returnString = String()
        returnString.append("{\n")
        returnString.append("""
                            "name": "\(name)",
                            "descriptions": "\(descriptions)",
                            "price": \(price),
                            "currency": "\(currency.rawValue)",
                            "secret": "\(secret)",
                            """)
        
        if let discountedPrice = discountedPrice {
            returnString.append("\n\"discounted_price\": \(discountedPrice),")
        }
        
        if let stock = stock {
            returnString.append("\n\"stock\": \(stock)")
        }
        
        returnString.append("\n}")
                        
        return returnString
    }
}


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
    
    func postData<T: Decodable>(identifier: String, paramter: Parameters, images: [UIImage], completion: @escaping (T) -> Void) {
        
        guard let url = URL(string: url) else { return }
        var postRequest = URLRequest(url: url)

        let boundary = generateBoundary()

        postRequest.httpMethod = "POST"
        postRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        postRequest.addValue(identifier, forHTTPHeaderField: "identifier")
        
        var convertedImages: [ImageInfo] = []
        images.forEach {
            guard let convertedImage = ImageInfo(withImage: $0) else { return }
            convertedImages.append(convertedImage)
        }
        
        let dataBody = createDataBody(withParameters: paramter, images: convertedImages, boundary: boundary)

        postRequest.httpBody = dataBody

        let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            if let response = response {
                print(response)
            }

            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    print(decodedData)
                    completion(decodedData)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func patchData<T: Decodable>(identifier: String, productID: Int, paramter: Parameters, completion: @escaping (T) -> Void) {
        
        guard let url = URL(string: url + "/\(productID)") else { return }
        var postRequest = URLRequest(url: url)

        let boundary = generateBoundary()

        postRequest.httpMethod = "PATCH"
        postRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        postRequest.addValue(identifier, forHTTPHeaderField: "identifier")
        
        _ = createDataBody(withParameters: paramter, images: nil, boundary: boundary)
        
        postRequest.httpBody = paramter.returnParamatersString().data(using: .utf8)
        print(paramter.returnParamatersString())
        
        let task = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            if let response = response {
                print(response)
            }

            if let data = data {
                guard let parsedData = try? JSONDecoder().decode(Page.self, from: data) else { return }
                print(parsedData)
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
    
    
}

// MARK: - generateBoundary

func generateBoundary() -> String {
    return "Boundary-\(UUID().uuidString)"
}

// MARK: - createDataBody

func createDataBody(withParameters params: Parameters, images: [ImageInfo]?, boundary: String) -> Data {

    let lineBreak = "\r\n"
    var body = Data()

    // parameter 넣기
    body.append("--\(boundary + lineBreak)")
    body.append("Content-Disposition: form-data; name=\"\(Parameters.key)\"\(lineBreak + lineBreak)")
    body.append("\(params.returnParamatersString() + lineBreak)")

    // image 넣기
    if let images = images {
        for image in images {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(ImageInfo.key)\"; filename=\"\(image.filename)\"\(lineBreak)")
            body.append("Content-Type: \(image.mimeType + lineBreak + lineBreak)")
            body.append(image.data)
            body.append(lineBreak)
        }
    }

    // 끝났다고 표시해주기
    body.append("--\(boundary)--\(lineBreak)")

    return body
}

// Data에 String을 추가해주는 메서드 정의
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
