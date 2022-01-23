import Foundation

struct ProductListAskRequester: APIRequestable, JSONResponseDecodable {
    var url: URL? {
        return URL(string: "\(baseURLString)?page_no=\(pageNo)&items_per_page=\(itemsPerPage)")
    }
    var httpMethod: HTTPMethod = .GET
    var httpBody: Data? = nil
    var headerFields: [String: String]? = nil
    
    typealias DecodingType = ProductListAsk.Response

    private var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    private let pageNo: Int
    let itemsPerPage: Int
    
    init(pageNo: Int, itemsPerPage: Int) {
        self.pageNo = pageNo
        self.itemsPerPage = itemsPerPage
    }
}
