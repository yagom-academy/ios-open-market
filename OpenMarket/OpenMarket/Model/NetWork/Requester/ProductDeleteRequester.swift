import Foundation

struct ProductDeleteRequester: Requestable, JSONResponseDecodable {
    var url: URL? {
        return URL(string: "\(baseURLString)/\(productId)/\(productSecret)")
    }
    var httpMethod: HTTPMethod = .POST
    var httpBody: Data? = nil
    var headerFields: [String: String]? = nil
    
    typealias DecodingType = ProductDelete.Response
    
    private var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    private let identifier: String
    private let productId: Int
    private let productSecret: String

    init(identifier: String, productId: Int, productSecret: String) {
        self.identifier = identifier
        self.productId = productId
        self.productSecret = productSecret
    }
}
