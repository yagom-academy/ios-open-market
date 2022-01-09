import Foundation

struct ProductDeleteRequester: Networkable {
    static var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    static var httpMethod: HttpMethod = .DELETE
    let identifier: String
    let productId: Int
    let productSecret: String

    var url: URL? {
        return URL(string: "\(Self.baseURLString)/\(productId)/\(productSecret)")
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
