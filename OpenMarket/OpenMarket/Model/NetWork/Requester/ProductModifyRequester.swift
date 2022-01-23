import Foundation

struct ProductModifyRequester: APIRequestable, JSONResponseDecodable {
    var url: URL? {
        return URL(string: "\(baseURLString)/\(productId)")
    }
    var httpMethod: HTTPMethod = .PATCH
    var httpBody: Data? = nil
    var headerFields: [String: String]? = nil
    
    typealias DecodingType = ProductModify.Response
    
    private let baseURLString = "https://market-training.yagom-academy.kr/api/products"
    private let identifier: String
    private let productId: Int
    private let secret: String
    
    init(identifier: String, productId: Int, secret: String) {
        self.identifier = identifier
        self.productId = productId
        self.secret = secret
    }
}
