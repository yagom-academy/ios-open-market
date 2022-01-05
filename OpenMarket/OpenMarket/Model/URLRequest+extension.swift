import Foundation

extension URLRequest {
    init(work: WorkType, method: HttpMethod) {
        self.init(url: work.url)
        self.timeoutInterval = TimeInterval(10)

        switch method {
        case .get:
            self.httpMethod = "GET"
        case .post:
            self.httpMethod = "POST"
        case .put:
            self.httpMethod = "PUT"
        case .patch:
            self.httpMethod = "PATCH"
        case .delete:
            self.httpMethod = "DELETE"
        }
    }
    
    enum HttpMethod {
        case get
        case post
        case put
        case patch
        case delete
    }
}
