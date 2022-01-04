import Foundation

enum HttpMethod<Body: Encodable> {
    case get
    case post(Body)
    case patch(Body)
    case delete
}

extension URLRequest {
    init<Body: Encodable>(url: URL, method: HttpMethod<Body>) {
        self.init(url: url)
        
        switch method {
        case .get:
            self.httpMethod = "GET"
        case .post(let body):
            self.httpMethod = "POST"
            self.httpBody = try? JSONEncoder().encode(body)
        case .patch(let body):
            self.httpMethod = "PATCH"
            self.httpBody = try? JSONEncoder().encode(body)
        case .delete:
            self.httpMethod = "DELETE"
        }
    }
}
