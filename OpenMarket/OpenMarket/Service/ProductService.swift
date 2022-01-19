import Foundation

struct ProductService: APIService {
    let venderIdentification = UserDefaultUtility().getVendorIdentification()

    func retrieveProduct(
        productIdentification: Int,
        session: URLSessionProtocol,
        completionHandler: @escaping ((Result<Product, NetworkingError>) -> Void)
    ) {
        let urlString = "\(HTTPUtility.baseURL)\(HTTPUtility.productPath)\(productIdentification)"
        guard let request = HTTPUtility.urlRequest(urlString: urlString) else {
            return
        }
        doDataTask(with: request, session: session) { result in
            completionHandler(result)
        }
    }

    func retrieveProductList(
        pageNumber: Int? = nil,
        itemsPerPage: Int? = nil,
        session: URLSessionProtocol,
        completionHandler: @escaping ((Result<ProductList, NetworkingError>) -> Void)
    ) {
        var urlString = "\(HTTPUtility.baseURL)\(HTTPUtility.productPath)"
        if let pageNumber = pageNumber,
           let itemsPerPage = itemsPerPage {
            urlString += "?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)"
        }
        guard let request = HTTPUtility.urlRequest(urlString: urlString) else {
            return
        }
        doDataTask(with: request, session: session) { result in
            completionHandler(result)
        }
    }

    func retrieveSecretOfProduct(
        identification: Int,
        body: SecretOfProductRequest,
        session: URLSessionProtocol,
        completionHandler: @escaping ((Result<String, NetworkingError>) -> Void)
    ) {
        let urlString = "\(HTTPUtility.baseURL)\(HTTPUtility.productPath)\(identification)/secret"
        guard var request = HTTPUtility.urlRequest(urlString: urlString, method: .post) else {
            return
        }
        request.addHTTPHeaders(
            headers: ["identifier": venderIdentification,
                      "Content-Type": "application/json"]
        )
        request.httpBody = try? JSONEncoder().encode(body)
        doDataTask(with: request, session: session) { result in
            completionHandler(result)
        }
    }

    func deleteProduct(
        identification: Int,
        productSecret: String,
        session: URLSessionProtocol,
        completionHandler: @escaping ((Result<Product, NetworkingError>) -> Void)
    ) {
        let urlString =
            "\(HTTPUtility.baseURL)\(HTTPUtility.productPath)\(identification)/\(productSecret)"
        guard var request = HTTPUtility.urlRequest(urlString: urlString, method: .delete) else {
            return
        }
        request.addHTTPHeaders(
            headers: ["identifier": venderIdentification,
                      "Content-Type": "application/json"]
        )
        doDataTask(with: request, session: session) { result in
            completionHandler(result)
        }
    }

    func modifyProduct(
        identification: Int,
        body: ProductModificationRequest,
        session: URLSessionProtocol,
        completionHandler: @escaping ((Result<Product, NetworkingError>) -> Void)
    ) {
        let urlString = "\(HTTPUtility.baseURL)\(HTTPUtility.productPath)\(identification)"
        guard var request = HTTPUtility.urlRequest(urlString: urlString, method: .patch) else {
            return
        }
        request.addHTTPHeaders(
            headers: ["identifier": venderIdentification,
                      "Content-Type": "application/json"]
        )
        request.httpBody = try? JSONEncoder().encode(body)
        doDataTask(with: request, session: session) { result in
            completionHandler(result)
        }
    }

    func registerProduct(
        parameters: RegisterProductRequest,
        session: URLSessionProtocol,
        images: [Data],
        completionHandler: @escaping ((Result<Product, NetworkingError>) -> Void)
    ) {
        let urlString = "\(HTTPUtility.baseURL)\(HTTPUtility.productPath)"
        guard var request = HTTPUtility.urlRequest(urlString: urlString, method: .post) else {
            return
        }
        let boundary: String = UUID().uuidString
        request.addHTTPHeaders(
            headers: ["identifier": venderIdentification,
                      "Content-Type": "multipart/form-data; boundary=\(boundary)"]
        )
        request.httpBody = makeMultipartFormData(
            parameters: parameters,
            images: images,
            boundary: boundary
        )
        doDataTask(with: request, session: session) { result in
            completionHandler(result)
        }
    }
}
