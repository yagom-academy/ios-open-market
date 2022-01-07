import Foundation

struct ProductService {
    private func doDataTask(
        with request: URLRequest,
        session: URLSessionProtocol,
        completionHandler: @escaping (Result<Data, NetworkingError>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completionHandler(.failure(.request))
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                return completionHandler(.failure(.response))
            }
            guard let data = data else {
                return completionHandler(.failure(.data))
            }
            completionHandler(.success(data))
        }
        task.resume()
    }

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
}
