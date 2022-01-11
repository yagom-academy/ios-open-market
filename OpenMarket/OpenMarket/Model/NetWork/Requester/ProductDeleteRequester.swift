import Foundation

struct ProductDeleteRequester: Requestable {
    private var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    private var httpMethod: HTTPMethod = .DELETE
    private let identifier: String
    private let productId: Int
    private let productSecret: String

    init(identifier: String, productId: Int, productSecret: String) {
        self.identifier = identifier
        self.productId = productId
        self.productSecret = productSecret
    }
    
    private var url: URL? {
        return URL(string: "\(baseURLString)/\(productId)/\(productSecret)")
    }
    
    var request: URLRequest? {
        guard let url = url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        return request
    }
}
