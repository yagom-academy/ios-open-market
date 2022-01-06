import Foundation

struct ProductService<Element: Decodable> {
    private func doDataTask(
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

    func retrieveProductList(
        session: URLSessionProtocol,
        completionHandler: @escaping ((Element) -> Void)
    ) {
        let urlString = HTTPUtility.baseURL + "/api/products"
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        doDataTask(with: request, session: session) { data in
            completionHandler(data)
        }
    }
}
