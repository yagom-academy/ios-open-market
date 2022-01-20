import Foundation

enum ProductRegistrationManager: JSONResponseDecodable {
    
    typealias Content = HTTPMessageMaker.Content
    
    static func request<T: URLSessionProtocol>(session: T,
                                               identifier: String,
                                               name: String,
                                               descriptions: String,
                                               price: Double,
                                               currency: String,
                                               discountedPrice: Double?,
                                               stock: Int?,
                                               secret: String,
                                               images: [Data],
                                               completion: @escaping (Result<Data, NetworkingAPIError>) -> Void) {
        
        let httpMethod = "POST"
        let urlString = "https://market-training.yagom-academy.kr/api/products"
        let boundary = UUID().uuidString
        let headerFields: [String: String] = ["identifier" : Vendor.identifier,
                                              "Content-Type" : "multipart/form-data; boundary=\(boundary)"]
        
        guard let currency = Currency(rawValue: currency) else {
            completion(.failure(.typeConversionFail))
            return
        }
        let params = Request(name: name,
                                    descriptions: descriptions,
                                    price: price,
                                    currency: currency,
                                    discountedPrice: discountedPrice,
                                    stock: stock,
                                    secret: secret)
        
        guard let httpBody = httpBody(boundary: boundary, params: params, images: images) else {
            completion(.failure(.HTTPBodyMakingFail))
            return
        }
        
        URLSession.shared.requestDataTask(urlString: urlString,
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
    
    private static func httpBody(boundary: String, params: Request, images: [Data]) -> Data? {
        var contents: [Content] = []
        
        let paramsHeaders = ["Content-Disposition:form-data; name=\"params\"", "Content-Type: application/json"]
        guard let paramsBody = try? JSONEncoder().encode(params) else {
            return nil
        }
        let paramsContent = Content(headers: paramsHeaders, body: paramsBody)
        contents.append(paramsContent)
        
        images.forEach {
            let headers = ["Content-Disposition:form-data; name=\"images\"; filename=\"\(UUID().uuidString).jpeg\"",
                           "Content-Type: image/jpeg"]
            let image = Content(headers: headers, body: $0)
            contents.append(image)
        }
        
        return HTTPMessageMaker.createdMultipartBody(boundary: boundary, contents: contents)
    }
}

//MARK: - ParsingType
extension ProductRegistrationManager {
    enum Currency: String, Codable {
        case KRW
        case USD
    }
    
    struct Request: Encodable {
        let name: String
        let descriptions: String
        let price: Double
        let currency: Currency
        let discountedPrice: Double?
        let stock: Int?
        let secret: String
        
        enum CodingKeys: String, CodingKey {
            case name, descriptions, price, currency, stock, secret
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
