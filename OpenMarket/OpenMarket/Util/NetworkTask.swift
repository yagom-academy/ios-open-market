import Foundation
import UIKit

enum NetworkTask {
    static let apiHost = "https://market-training.yagom-academy.kr"
    
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
    
    private func buildBody(with salesInformation: SalesInformation, images: [Data]) -> Data? {
        let boundary = "XXXXX"
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
        var body = ""
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition:form-data; name=\"params\"\r\n")
        guard let paramsBody = body.data(using: .utf8) else {
            return nil
        }
        data.append(paramsBody)
        data.append(salesInformation)
        data.append(endBoundary)
        body = ""
        body.append("\r\n--\(boundary)\r\n")
        body.append("Content-Disposition:form-data; name=\"images\"\r\n")
        guard let imagesBody = body.data(using: .utf8) else {
            return nil
        }
        data.append(imagesBody)
        for image in images {
            data.append(newLine)
            data.append(image)
        }
        data.append(endBoundary)
        return data
    }
}
