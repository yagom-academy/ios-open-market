import Foundation

struct ProductSecretAskRequester: Requestable {
    private static var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    private static var httpMethod: HttpMethod = .POST
    private let productId: Int
    private let identifier: String
    private let secret: String
    
    init(productId: Int, identifier: String, secret: String) {
        self.productId = productId
        self.identifier = identifier
        self.secret = secret
    }
    
    private var url: URL? {
        return URL(string: "\(Self.baseURLString)/\(productId)/secret")
    }
    
    var request: URLRequest? {
        guard let url = url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = Self.httpMethod.rawValue
        
        //TODO: need to add Body
        
        return request
    }
}
