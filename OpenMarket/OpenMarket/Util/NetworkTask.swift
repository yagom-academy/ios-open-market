import UIKit

enum NetworkTask {
    static let apiHost = "https://market-training.yagom-academy.kr"
    static let boundary = "XXXXX"
    
    static func requestHealthChekcer(completionHandler: @escaping (Data) -> Void) {
        guard let url = URL(string: apiHost + "/healthChecker") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  200 == httpResponse.statusCode else {
                      print(response)
                      return
                  }
            guard let data = data, httpResponse.mimeType == "text/plain" else { return }
            completionHandler(data)
        }
        task.resume()
    }
    
    static func requestProductRegistration(identifier: String,
                                           salesInformation: SalesInformation,
                                           images: [String: Data],
                                           completionHandler: @escaping (Data) -> Void) {
        guard let url = URL(string: apiHost + "/api/products") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(identifier, forHTTPHeaderField: "identifier")
        request.addValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        let body = buildBody(with: salesInformation, images: images)
        request.httpBody = body
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      print(response)
                      return
                  }
            guard let data = data, httpResponse.mimeType == "application/json" else { return }
            completionHandler(data)
        }
        task.resume()
    }
    
    static func requestProductDetail(productId: Int, completionHandler: @escaping (Data) -> Void) {
        guard let url = URL(string: apiHost + "/api/products/" + String(productId)) else { return }
        let task = URLSession.shared.dataTask(with: url) {  data, response, error in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      print(response)
                      return
                  }
            guard let data = data, httpResponse.mimeType == "application/json" else { return }
            completionHandler(data)
        }
        task.resume()
    }
    
    static func requestProductList(pageNumber: Int,
                                   itemsPerPage: Int,
                                   completionHandler: @escaping (Data) -> Void) {
        var urlComponents = URLComponents(string: apiHost + "/api/products?")
        let pageNumber = URLQueryItem(name: "page_no", value: String(pageNumber))
        let itemsPerPage = URLQueryItem(name: "items_per_page", value: String(itemsPerPage))
        urlComponents?.queryItems?.append(pageNumber)
        urlComponents?.queryItems?.append(itemsPerPage)
        guard let url = urlComponents?.url else { return }
        
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
            guard let data = data, httpResponse.mimeType == "application/json" else { return }
            completionHandler(data)
        }
        task.resume()
    }
    
    private static func buildBody(with salesInformation: SalesInformation,
                                  images: [String: Data]) -> Data? {
        guard let endBoundary = "\r\n--\(boundary)--".data(using: .utf8) else {
            return nil
        }
        guard let newLine = "\r\n".data(using: .utf8) else {
            return nil
        }
        guard let salesInformation = try? JSONParser.encode(from: salesInformation) else {
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
        for (fileName, image) in images {
            var imagesBody = ""
            imagesBody.append("\r\n--\(boundary)\r\n")
            imagesBody.append("Content-Disposition: form-data; name=\"images\"; filename=\(fileName)\r\n")
            guard let imagesBody = imagesBody.data(using: .utf8) else {
                return nil
            }
            data.append(imagesBody)
            data.append(newLine)
            data.append(image)
        }
        data.append(endBoundary)
        return data
    }
}
