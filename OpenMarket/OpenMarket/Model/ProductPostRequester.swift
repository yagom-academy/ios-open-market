import Foundation

struct ProductPostRequester: Networkable {
    let HttpMethod: HttpMethod = .POST
    let identifier: String
    let params: ProductPost.Request.Params
    let images: Data
    
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
