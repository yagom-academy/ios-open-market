import Foundation

struct HealthCheckerRequester: Requestable {
    private static var baseURLString: String = "https://market-training.yagom-academy.kr/healthChecker"
    private static var httpMethod: HttpMethod = .GET
    
    private var url: URL? {
        return URL(string: Self.baseURLString)
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
