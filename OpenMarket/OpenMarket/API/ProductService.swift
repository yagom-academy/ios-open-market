import Foundation

struct ProductService {
    private func doDataTask<Element: Decodable>(
        with request: URLRequest,
        session: URLSessionProtocol,
        completionHandler: @escaping (Element) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                let data: Element = try JSONDecoder().decode(Element.self, from: data)
                completionHandler(data)
            } catch {
                return
            }
        }
        task.resume()
    }

    func retrieveProduct(
        productIdentification: Int,
        session: URLSessionProtocol,
        completionHandler: @escaping ((Product) -> Void)
    ) {
        let urlString = "\(HTTPUtility.baseURL)/api/products/\(productIdentification)"
        guard let request = HTTPUtility.urlRequest(urlString: urlString) else {
            return
        }
        doDataTask(with: request, session: session) { data in
            completionHandler(data)
        }
    }

    func retrieveProductList(
        pageNumber: Int? = nil,
        itemsPerPage: Int? = nil,
        session: URLSessionProtocol,
        completionHandler: @escaping ((ProductList) -> Void)
    ) {
        var urlString = "\(HTTPUtility.baseURL)/api/products"
        if let pageNumber = pageNumber,
           let itemsPerPage = itemsPerPage {
            urlString += "?page-no=\(pageNumber)&items-per-page=\(itemsPerPage)"
        }
        guard let request = HTTPUtility.urlRequest(urlString: urlString) else {
            return
        }
        doDataTask(with: request, session: session) { data in
            completionHandler(data)
        }
    }
}
