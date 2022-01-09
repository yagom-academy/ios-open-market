import Foundation

struct ProductSecretAskRequester: Networkable {
    static var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    static var httpMethod: HttpMethod = .POST
    let productId: Int
    let identifier: String
    let secret: String
    
    var url: URL? {
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
