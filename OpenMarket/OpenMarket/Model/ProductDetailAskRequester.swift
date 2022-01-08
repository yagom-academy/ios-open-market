import Foundation

struct ProductDetailAskRequester: Networkable {
    static var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    static var httpMethod: HttpMethod = .GET
    let productId: Int

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
