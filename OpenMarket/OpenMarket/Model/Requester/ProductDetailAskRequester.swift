import Foundation

struct ProductDetailAskRequester: Requestable, JSONParsable {
    private static var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    private static var httpMethod: HttpMethod = .GET
    private let productId: Int

    init(productId: Int) {
        self.productId = productId
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
        
        return request
    }
}
