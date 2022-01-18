import Foundation

enum ProductDeleteSecretQueryManager {
    static func request<T: URLSessionProtocol>(session: T,
                                               productId: Int,
                                               identifier: String,
                                               secret: String,
                                               completion: @escaping (Result<Data, NetworkingError>) -> Void) {

        let httpMethod = "POST"
        let baseURLString = "https://market-training.yagom-academy.kr/api/products"
        let urlString = "\(baseURLString)/\(productId)/secret"
        
        let request = Request(secret: secret)
        
        //TODO: - make HTTPBody
        //TODO: - call dataTask
    }
}

//MARK: - Parsing Type
extension ProductDeleteSecretQueryManager {
    struct Request: Encodable {
        let secret: String
    }
}
