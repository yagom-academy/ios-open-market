import Foundation

struct ProductSecretAskRequester: Requestable {
    var url: URL? {
        return URL(string: "\(baseURLString)/\(productId)/secret")
    }
    var httpMethod: HTTPMethod = .POST
    var httpBody: Data? = nil
    var headerFields: [String: String]? = nil

    private let baseURLString = "https://market-training.yagom-academy.kr/api/products"
    private let productId: Int
    private let identifier: String
    private let secret: String
    
    init(productId: Int, identifier: String, secret: String) {
        self.productId = productId
        self.identifier = identifier
        self.secret = secret
    }
}
