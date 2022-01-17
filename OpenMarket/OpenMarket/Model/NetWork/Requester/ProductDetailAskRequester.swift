import Foundation

struct ProductDetailAskRequester: Requestable, JSONResponseDecodable {
    var url: URL? {
        return URL(string: "\(baseURLString)/\(productId)")
    }
    var httpMethod: HTTPMethod = .GET
    var httpBody: Data? = nil
    var headerFields: [String: String]? = nil
    
    typealias DecodingType = ProductDetailAsk.Response
    
    private var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    private let productId: Int

    init(productId: Int) {
        self.productId = productId
    }
}
