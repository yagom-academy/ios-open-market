import Foundation

struct ProductListAskRequester: Networkable {
    let HttpMethod: HttpMethod = .GET
    let pageNo: Int
    let itemPerPage: Int
    
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
