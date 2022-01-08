import Foundation

struct ProductDeleteRequester: Networkable {
    static var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    static var httpMethod: HttpMethod = .DELETE
    let identifier: String
    let productId: Int
    let productSecret: String

    var url: URL? {
        return URL(string: "\(Self.baseURLString)/\(productId)/\(productSecret)")
    }
    
    func creatURLRequest(httpMethod: HttpMethod, url: URL) -> URLRequest {
        <#code#>
    }
    
    func request() {
        <#code#>
    }
    
    
}
