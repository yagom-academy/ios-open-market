
import Foundation

struct ProductModifyRequester: Networkable {
    static var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    static var httpMethod: HttpMethod = .PATCH
    let identifier: String
    let productId: Int
    let secret: Int

    var url: URL? {
        return URL(string: "\(Self.baseURLString)/\(productId)")
    }
    
    func creatURLRequest(httpMethod: HttpMethod, url: URL) -> URLRequest {
        <#code#>
    }
    
    func request() {
        <#code#>
    }
}
