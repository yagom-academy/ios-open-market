import Foundation

struct ProductListAskRequester: Networkable, JSONParsable {
    static var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    static var httpMethod: HttpMethod = .POST
    let pageNo: Int
    let itemsPerPage: Int
    
    var url: URL? {
        return URL(string: "\(Self.baseURLString)?page_no=\(pageNo)&items_per_page=\(itemsPerPage)")
    }
    
    var request: URLRequest? {
        guard let url = url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = Self.httpMethod.rawValue
        return request
    }
}
