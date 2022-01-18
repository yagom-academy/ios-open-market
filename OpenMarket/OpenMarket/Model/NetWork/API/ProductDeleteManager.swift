import Foundation

enum ProductDeleteManager: JSONResponseDecodable {
    static func request<T: URLSessionProtocol>(session: T,
                                               identifier: String,
                                               productId: Int,
                                               productSecret: String,
                                               completion: @escaping (Result<Data, NetworkingError>) -> Void) {
        let httpMethod = "DELETE"
        let baseURLString = "https://market-training.yagom-academy.kr/api/products"
        let urlString = "\(baseURLString)/\(productId)/\(productSecret)"
        
        session.requestDataTask(urlString: urlString,
                                          httpMethod: httpMethod,
                                          httpBody: nil,
                                          headerFields: nil,
                                          completion: completion)
    }
}

//MARK: - Parsing Type
extension ProductDeleteManager {
    struct Response: Decodable {
        enum Currency: String, Codable {
            case KRW
            case USD
        }
        
        let id: Int
        let vendorId: Int
        let name: String
        let thumbnail: String
        let currency: Currency
        let price: Double
        let bargainPrice: Double
        let discountedPrice: Double
        let stock: Int
        let images: [Image]
        let vendors: Vendor
        let createdAt: String
        let issuedAt: String

        enum CodingKeys: String, CodingKey {
            case id, name, thumbnail, currency, price, stock, images, vendors
            case vendorId = "vendor_id"
            case bargainPrice = "bargain_price"
            case discountedPrice = "discounted_price"
            case createdAt = "created_at"
            case issuedAt = "issued_at"
        }
        
        struct Image: Decodable {
            let id: Int
            let url: String
            let thumbnailUrl: String
            let succeed: Bool
            let issuedAt: String
            
            enum CodingKeys: String, CodingKey {
                case id, url, succeed
                case thumbnailUrl = "thumbnail_url"
                case issuedAt = "issued_at"
            }
        }
        
        struct Vendor: Decodable {
            let name: String
            let id: Int
            let createdAt: String
            let issuedAt: String
            
            enum CodingKeys: String, CodingKey {
                case name, id
                case createdAt = "created_at"
                case issuedAt = "issued_at"
            }
        }
    }
}
