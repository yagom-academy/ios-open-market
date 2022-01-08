import Foundation

struct ProductSecretAskRequester: Networkable {
    static var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    static var httpMethod: HttpMethod = .POST
    let productId: Int
    let identifier: String
    let secret: String
    
    var url: URL? {
        return URL(string: "\(Self.baseURLString)/\(productId)/secret")
    }
    
    func creatURLRequest(httpMethod: HttpMethod, url: URL) -> URLRequest {
        <#code#>
    }
    
    func request() {
        <#code#>
    }
    
    
}
