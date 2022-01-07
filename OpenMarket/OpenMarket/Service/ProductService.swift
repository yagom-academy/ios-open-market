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
}
