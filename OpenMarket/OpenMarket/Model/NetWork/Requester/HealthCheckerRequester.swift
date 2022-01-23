import Foundation

struct HealthCheckerRequester: APIRequestable {
    var url: URL? {
        return URL(string: "https://market-training.yagom-academy.kr/healthChecker")
    }
    var httpMethod: HTTPMethod = .GET
    var httpBody: Data? = nil
    var headerFields: [String: String]? = nil
}
