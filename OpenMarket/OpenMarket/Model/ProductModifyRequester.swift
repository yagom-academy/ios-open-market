
import Foundation

struct ProductModifyRequester: Networkable {
    static var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    static var httpMethod: HttpMethod = .PATCH
    let identifier: String
    let productId: Int
    let secret: Int

    var url: URL? {
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
