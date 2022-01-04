import Foundation

enum NetworkTask {
    static let apiHost = "https://market-training.yagom-academy.kr"
    
    static func requestProductList(pageNumber: Int,
                                   itemsPerPage: Int,
                                   completionHandler: @escaping (Data) -> Void) {
        var urlComponents = URLComponents(string: apiHost + "/api/products?")
        let pageNumber = URLQueryItem(name: "page_no", value: String(pageNumber))
        let itemsPerPage = URLQueryItem(name: "items_per_page", value: String(itemsPerPage))
        urlComponents?.queryItems?.append(pageNumber)
        urlComponents?.queryItems?.append(itemsPerPage)
        guard let url = urlComponents?.url else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                print(response)
                return
            }
            guard httpResponse.mimeType == "application/json",
                let data = data else {
                return
            }
            completionHandler(data)
        }
        task.resume()
    }
}
