import Foundation

struct ProductDetailAskRequester: Networkable, JSONParsable {

    static var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    static var httpMethod: HttpMethod = .GET
    let productId: Int

    var url: URL? {
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
