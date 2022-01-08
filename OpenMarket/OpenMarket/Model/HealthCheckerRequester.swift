import Foundation

struct HealthCheckerRequester: Networkable {
    static var baseURLString: String = "https://market-training.yagom-academy.kr/healthChecker"
    static var httpMethod: HttpMethod = .GET
    
    var url: URL? {
        return URL(string: Self.baseURLString)
    }
    
    func request() {
        <#code#>
    }
    
    
}
