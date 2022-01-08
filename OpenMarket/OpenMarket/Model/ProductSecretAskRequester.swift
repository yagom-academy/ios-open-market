import Foundation

struct ProductSecretAskRequester: Networkable {
    let HttpMethod: HttpMethod = .GET
    let productId: Int
    let identifier: String
    let secret: String
    
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
