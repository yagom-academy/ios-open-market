import Foundation

struct ProductPostRequester: APIRequestable, JSONResponseDecodable {
    var url: URL? {
        return URL(string: "https://market-training.yagom-academy.kr/api/products")
    }
    var httpMethod: HTTPMethod = .POST
    var httpBody: Data? = nil
    var headerFields: [String: String]? = nil
    
    typealias DecodingType = ProductPost.Response

    private let identifier: String
    private let params: ProductPost.Request.Params
    private let images: Data
    
    init(identifier: String, params: ProductPost.Request.Params, images: Data) {
        self.identifier = identifier
        self.params = params
        self.images = images
    }
}
