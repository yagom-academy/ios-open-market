import Foundation

struct ProductService: APIService {
    func retrieveProduct(
        productIdentification: Int,
        session: URLSessionProtocol,
        completionHandler: @escaping ((Result<Data, NetworkingError>) -> Void)
    ) {
        let urlString = "\(HTTPUtility.baseURL)/api/products/\(productIdentification)"
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
        completionHandler: @escaping ((Result<Data, NetworkingError>) -> Void)
    ) {
        var urlString = "\(HTTPUtility.baseURL)/api/products"
        if let pageNumber = pageNumber,
           let itemsPerPage = itemsPerPage {
            urlString += "?page-no=\(pageNumber)&items-per-page=\(itemsPerPage)"
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
        completionHandler: @escaping ((Result<Data, NetworkingError>) -> Void)
    ) {
        let urlString = "\(HTTPUtility.baseURL)/api/products/\(identification)/secret"
        guard var request = HTTPUtility.urlRequest(urlString: urlString, method: .post) else {
            return
        }
        request.addHTTPHeaders(headers: HTTPUtility.defaultHeader)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        doDataTask(with: request, session: session) { result in
            completionHandler(result)
        }
    }

    func deleteProduct(
        identification: Int,
        productSecret: String,
        session: URLSessionProtocol,
        completionHandler: @escaping ((Result<Data, NetworkingError>) -> Void)
    ) {
        let urlString = "\(HTTPUtility.baseURL)/api/products/\(identification)/\(productSecret)"
        guard var request = HTTPUtility.urlRequest(urlString: urlString, method: .delete) else {
            return
        }
        request.addHTTPHeaders(headers: HTTPUtility.defaultHeader)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        doDataTask(with: request, session: session) { result in
            completionHandler(result)
        }
    }

    func modifyProduct(
        identification: Int,
        body: ProductModificationRequest,
        session: URLSessionProtocol,
        completionHandler: @escaping ((Result<Data, NetworkingError>) -> Void)
    ) {
        let urlString = "\(HTTPUtility.baseURL)/api/products/\(identification)"
        guard var request = HTTPUtility.urlRequest(urlString: urlString, method: .patch) else {
            return
        }
        request.addHTTPHeaders(headers: HTTPUtility.defaultHeader)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        doDataTask(with: request, session: session) { result in
            completionHandler(result)
        }
    }
}
