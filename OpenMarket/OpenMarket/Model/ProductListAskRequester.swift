import Foundation

struct ProductListAskRequester: Networkable {
    static var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    static var httpMethod: HttpMethod = .POST
    let pageNo: Int
    let itemsPerPage: Int
    
    var url: URL? {
        return URL(string: "\(Self.baseURLString)?page_no=\(pageNo)&items_per_page=\(itemsPerPage)")
    }
    
    func creatURLRequest(httpMethod: HttpMethod, url: URL) -> URLRequest {
        <#code#>
    }
    
    func request() {
        <#code#>
    }
    
    
}
