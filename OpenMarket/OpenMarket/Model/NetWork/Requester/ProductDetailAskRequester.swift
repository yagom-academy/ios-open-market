import Foundation

struct ProductDetailAskRequester: Requestable {
    private var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    private var httpMethod: HTTPMethod = .GET
    private let productId: Int

    init(productId: Int) {
        self.productId = productId
    }
    
    private var url: URL? {
        return URL(string: "\(baseURLString)/\(productId)")
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
