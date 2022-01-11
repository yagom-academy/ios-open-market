import Foundation

enum HTTPUtility {
    static let baseURL = "https://market-training.yagom-academy.kr/"
    static let productPath = "api/products/"
    static let defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()

    static func urlRequest(urlString: String, method: HttpMethod = .get) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }

    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
}

extension URLRequest {
    mutating func addHTTPHeaders(headers: [String: String?]) {
        for (key, value) in headers {
            guard let value = value else {
                return
            }
            self.addValue(value, forHTTPHeaderField: key)
        }
    }
}
