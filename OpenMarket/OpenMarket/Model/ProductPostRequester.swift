import Foundation

struct ProductPostRequester: Networkable {
    static var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    static var httpMethod: HttpMethod = .POST
    let identifier: String
    let params: ProductPost.Request.Params
    let images: Data
    
    var url: URL? {
        return URL(string: Self.baseURLString)
    }
    
    func creatURLRequest(httpMethod: HttpMethod, url: URL) -> URLRequest {
        <#code#>
    }
    
    func request() {
        <#code#>
    }
    
    
}
