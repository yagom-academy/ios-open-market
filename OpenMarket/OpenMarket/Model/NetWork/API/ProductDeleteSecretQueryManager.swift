import Foundation

enum ProductDeleteSecretQueryManager {
    static func request<T: URLSessionProtocol>(session: T,
                                               productId: Int,
                                               identifier: String,
                                               secret: String,
                                               completion: @escaping (Result<Data, OpenMarketError>) -> Void) {

        let httpMethod = "POST"
        let baseURLString = "https://market-training.yagom-academy.kr/api/products"
        let urlString = "\(baseURLString)/\(productId)/secret"
        let headerFields: [String: String] = [
            "Content-Type" : "application/json",
            "identifier" : Vendor.identifier
        ]
        let request = Request(secret: secret)
        
        guard let httpBody = httpBody(secret: request) else {
            print(OpenMarketError.encodingFail("ProductDeleteSecretQueryManager.Request", "Data").description)
            return
        }
        
        session.requestDataTask(urlString: urlString,
                                          httpMethod: httpMethod,
                                          httpBody: httpBody,
                                          headerFields: headerFields) {
            
            (result) in
            
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private static func httpBody(secret: Request) -> Data? {
        return try? JSONEncoder().encode(secret)
    }
}

//MARK: - Parsing Type
extension ProductDeleteSecretQueryManager {
    struct Request: Encodable {
        let secret: String
    }
}
