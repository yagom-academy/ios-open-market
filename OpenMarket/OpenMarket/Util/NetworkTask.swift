import Foundation

struct NetworkTask {
    private let boundary = UUID().uuidString
    let jsonParser: JSONParsable
    
    func requestHealthChekcer(completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard let url = NetworkAddress.healthChecker.url else { return }
        let request = URLRequest(url: url)
        let task = dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
    func requestProductRegistration(
        identifier: String,
        salesInformation: SalesInformation,
        images: [String: Data],
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = NetworkAddress.productRegistration.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(identifier, forHTTPHeaderField: "identifier")
        request.addValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )
        let body = buildBody(with: salesInformation, images: images)
        request.httpBody = body
        let task = dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
    func requestProductModification(
        identifier: String,
        productId: Int,
        information: ModificationInformation,
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = NetworkAddress.productModification(productId: productId).url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue(identifier, forHTTPHeaderField: "identifier")
        request.httpBody = try? jsonParser.encode(from: information)
        let task = dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
    func requestProductSecret(
        productId: Int,
        identifier: String,
        secret: String,
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = NetworkAddress.secret(productId: productId).url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(identifier, forHTTPHeaderField: "identifier")
        request.httpBody = try? jsonParser.encode(from: secret)
        let task = dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
    func requestRemoveProduct(
        identifier: String,
        productId: Int,
        productSecret: String,
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = NetworkAddress.removeProduct(
            productId: productId,
            productSecret: productSecret).url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue(identifier, forHTTPHeaderField: "identifier")
        request.httpBody = try? jsonParser.encode(from: productSecret)
        let task = dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
    func requestProductDetail(
        productId: Int,
        completionHandler: @escaping (Result<Data, Error>) -> Void) {
            guard let url = NetworkAddress.productDetail(productId: productId).url else { return }
            let request = URLRequest(url: url)
            let task = dataTask(with: request, completionHandler: completionHandler)
            task.resume()
        }
    
    func requestProductList(
        pageNumber: Int,
        itemsPerPage: Int,
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = NetworkAddress.productList(
            pageNumber: pageNumber,
            itemsPerPage: itemsPerPage).url else { return }
        let request = URLRequest(url: url)
        let task = dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
    private func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      completionHandler(.failure(NetworkError.httpError))
                      return
                  }
            guard let data = data else { return }
            completionHandler(.success(data))
        }
        return dataTask
    }
    
    private func buildBody(
        with salesInformation: SalesInformation,
        images: [String: Data]
    ) -> Data? {
        guard let endBoundary = "\r\n--\(boundary)--".data(using: .utf8) else {
            return nil
        }
        guard let newLine = "\r\n".data(using: .utf8) else {
            return nil
        }
        guard let salesInformation = try? jsonParser.encode(from: salesInformation) else {
            return nil
        }
        var data = Data()
        var paramsBody = ""
        paramsBody.append("--\(boundary)\r\n")
        paramsBody.append("Content-Disposition: form-data; name=\"params\"\r\n\r\n")
        guard let paramsBody = paramsBody.data(using: .utf8) else {
            return nil
        }
        data.append(paramsBody)
        data.append(salesInformation)
        images.forEach { (fileName, image) in
            var imagesBody = ""
            imagesBody.append("\r\n--\(boundary)\r\n")
            imagesBody.append(
                "Content-Disposition: form-data; name=\"images\"; filename=\(fileName)\r\n"
            )
            guard let imagesBody = imagesBody.data(using: .utf8) else { return }
            data.append(imagesBody)
            data.append(newLine)
            data.append(image)
        }
        data.append(endBoundary)
        return data
    }
}

extension NetworkTask {
    private enum NetworkAddress {
        static let apiHost = "https://market-training.yagom-academy.kr"
        
        case healthChecker
        case productRegistration
        case productModification(productId: Int)
        case productDetail(productId: Int)
        case productList(pageNumber: Int, itemsPerPage: Int)
        case secret(productId: Int)
        case removeProduct(productId: Int, productSecret: String)
        
        var url: URL? {
            switch self {
            case .healthChecker:
                return URL(string: Self.apiHost + "/healthChecker")
            case .productRegistration:
                return URL(string: Self.apiHost + "/api/products")
            case let .productModification(productId):
                return URL(string: Self.apiHost + "/api/products/\(productId)")
            case let .productDetail(productId):
                return URL(string: Self.apiHost + "/api/products/" + String(productId))
            case let .productList(pageNumber, itemsPerPage):
                var urlComponents = URLComponents(string: Self.apiHost + "/api/products?")
                let pageNumber = URLQueryItem(name: "page_no", value: String(pageNumber))
                let itemsPerPage = URLQueryItem(
                    name: "items_per_page", value: String(itemsPerPage)
                )
                urlComponents?.queryItems?.append(pageNumber)
                urlComponents?.queryItems?.append(itemsPerPage)
                return urlComponents?.url
            case let .secret(productId):
                return URL(string: Self.apiHost + "/api/products/\(productId)/secret")
            case let .removeProduct(productId, productSecret):
                return URL(string: Self.apiHost + "/api/products/\(productId)/\(productSecret)")
            }
        }
    }
    
    struct SalesInformation: Encodable {
        var name: String
        var descriptions: String
        var price: Double
        var currency: Currency
        var discountedPrice: Double?
        var stock: Int?
        var secret: String
    }
    
    struct ModificationInformation: Encodable {
        var name: String?
        var descriptions: String?
        var thumbnail_id: Int?
        var price: Int?
        var currency: Currency?
        var discountedPrice: Double?
        var stock: Int?
        var secret: String
    }
}
