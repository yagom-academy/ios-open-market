import Foundation

struct ProductModifyRequester: Requestable {
    private static var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    private static var httpMethod: HttpMethod = .PATCH
    private let identifier: String
    private let productId: Int
    private let secret: String
    
    init(identifier: String, productId: Int, secret: String) {
        self.identifier = identifier
        self.productId = productId
        self.secret = secret
    }

    private var url: URL? {
        return URL(string: "\(Self.baseURLString)/\(productId)")
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
