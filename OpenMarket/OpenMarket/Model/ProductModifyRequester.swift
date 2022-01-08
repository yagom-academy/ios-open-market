
import Foundation

struct ProductModifyRequester: Networkable {
    let HttpMethod: HttpMethod = .PATCH
    let identifier: String
    let productId: Int
    let secret: Int
    
    
    func creatURL() {
        
    }
    
    func creatURLRequest(httpMethod: HttpMethod, url: URL) -> URLRequest {
        <#code#>
    }
    
    func request() {
        <#code#>
    }
}
