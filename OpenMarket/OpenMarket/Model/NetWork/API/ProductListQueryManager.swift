import Foundation

enum ProductListQueryManager: JSONResponseDecodable {
    static func request<T: URLSessionProtocol>(session: T,
                                               pageNo: Int,
                                               itemsPerPage: Int,
                                               completion: @escaping (Result<Data, NetworkingError>) -> Void) {
        
        let httpMethod = "GET"
        let baseURLString = "https://market-training.yagom-academy.kr/api/products"
        let urlString = "\(baseURLString)?page_no=\(pageNo)&items_per_page=\(itemsPerPage)"
        
        session.requestDataTask(urlString: urlString,
                                          httpMethod: httpMethod,
                                          httpBody: nil,
                                          headerFields: nil,
                                          completion: completion)
    }
}

//MARK: - Parsing Type
extension ProductListQueryManager {
    enum Currency: String, Codable {
        case KRW
        case USD
    }
    
    struct Response: Decodable {
        let pageNo: Int
        let itemsPerPage: Int
        let totalCount: Int
        let offset: Int
        let limit: Int
        let lastPage: Int
        let hasNext: Bool
        let hasPrev: Bool
        let pages: [Page]
        
        enum CodingKeys: String, CodingKey {
            case offset, limit, pages
            case pageNo = "page_no"
            case itemsPerPage = "items_per_page"
            case totalCount = "total_count"
            case lastPage = "last_page"
            case hasNext = "has_next"
            case hasPrev = "has_prev"
        }
        
        struct Page: Decodable, Hashable {
            let id: Int
            let vendorId: Int
            let name: String
            let thumbnail: String
            let currency: Currency
            let price: Double
            let bargainPrice: Double
            let discountedPrice: Double
            let stock: Int
            let createdAt: String
            let issuedAt: String
            
            enum CodingKeys: String, CodingKey {
                case id, name, thumbnail, currency, price, stock
                case vendorId = "vendor_id"
                case bargainPrice = "bargain_price"
                case discountedPrice = "discounted_price"
                case createdAt = "created_at"
                case issuedAt = "issued_at"
            }
        }
    }
}

