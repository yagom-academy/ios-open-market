import Foundation

struct ProductListAskRequester: Requestable {
    private static var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    private static var httpMethod: HTTPMethod = .POST
    private let pageNo: Int
    private let itemsPerPage: Int
    
    init(pageNo: Int, itemsPerPage: Int) {
        self.pageNo = pageNo
        self.itemsPerPage = itemsPerPage
    }
    
    private var url: URL? {
        return URL(string: "\(baseURLString)?page_no=\(pageNo)&items_per_page=\(itemsPerPage)")
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
