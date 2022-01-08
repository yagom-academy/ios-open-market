import Foundation

struct ProductDeleteRequester: Networkable {
    let HttpMethod: HttpMethod = .DELETE
    let identifier: String
    let productId: Int
    let productSecret: String
    
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
