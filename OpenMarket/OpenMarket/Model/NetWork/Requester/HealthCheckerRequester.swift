import Foundation

struct HealthCheckerRequester: Requestable {
    private var baseURLString: String = "https://market-training.yagom-academy.kr/healthChecker"
    private var httpMethod: HTTPMethod = .GET
    
    private var url: URL? {
        return URL(string: baseURLString)
    }
    
    var request: URLRequest? {
        guard let url = url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = Self.httpMethod.rawValue
        
        return request
    }
}
