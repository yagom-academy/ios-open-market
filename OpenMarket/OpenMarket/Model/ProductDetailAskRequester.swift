import Foundation

struct ProductDetailAskRequester: Networkable {
    let HttpMethod: HttpMethod = .GET
    let productId: Int
    
    func creatURL() {
        <#code#>
    }
    
    func creatURLRequest(httpMethod: HttpMethod, url: URL) -> URLRequest {
        <#code#>
    }
    
    func request() {
        <#code#>
    }
    
    
}
