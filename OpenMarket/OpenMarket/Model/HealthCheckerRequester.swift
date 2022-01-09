import Foundation

struct HealthCheckerRequester: Networkable {
    static var baseURLString: String = "https://market-training.yagom-academy.kr/healthChecker"
    static var httpMethod: HttpMethod = .GET
    
    var url: URL? {
        return URL(string: Self.baseURLString)!
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
