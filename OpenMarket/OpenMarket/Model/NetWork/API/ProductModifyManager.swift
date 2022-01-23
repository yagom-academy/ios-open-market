import Foundation

enum ProductModifyManager: JSONResponseDecodable {
    static func request<T: URLSessionProtocol>(session: T,
                                               identifier: String,
                                               productId: Int,
                                               name: String?,
                                               description: String?,
                                               thumbnailId: Int?,
                                               price: Double?,
                                               currency: Currency?,
                                               discountedPrice: Double?,
                                               stock: Int?,
                                               secret: String,
                                               completion: @escaping (Result<Data, OpenMarketError>) -> Void) {

        let httpMethod = "PATCH"
        let baseURLString = "https://market-training.yagom-academy.kr/api/products"
        let urlString = "\(baseURLString)/\(productId)"
        
        let request = Request(name: name,
                              description: description,
                              thumbnailId: thumbnailId,
                              price: price,
                              currency: currency,
                              discountedPrice: discountedPrice,
                              stock: stock,
                              secret: secret)
        
        //TODO: - make HTTPBody
        //TODO: - call dataTask
    }
}

//MARK: - Parsing Type
extension ProductModifyManager {
    enum Currency: String, Codable {
        case KRW
        case USD
    }
    
    struct Request: Encodable {
        let name: String?
        let description: String?
        let thumbnailId: Int?
        let price: Double?
        let currency: Currency?
        let discountedPrice: Double?
        let stock: Int?
        let secret: String
        
        enum CodingKeys: String, CodingKey {
            case name, description, price, currency, stock, secret
            case thumbnailId = "thumbnail_id"
            case discountedPrice = "discounted_price"
        }
    }
    
    struct Response: Decodable {
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
        
        struct Image: Codable {
            let id: Int
            let url: String
            let thumbnailUrl: String
            let succeed: Bool?
            let issuedAt: String
            
            enum CodingKeys: String, CodingKey {
                case id, url, succeed
                case thumbnailUrl = "thumbnail_url"
                case issuedAt = "issued_at"
            }
        }
        
        struct Vendor: Codable {
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
