import Foundation

struct ProductPostRequester: Requestable {
    private var baseURLString: String = "https://market-training.yagom-academy.kr/api/products"
    private var httpMethod: HTTPMethod = .POST
    private let identifier: String
    private let params: ProductPost.Request.Params
    private let images: Data
    
    init(identifier: String, params: ProductPost.Request.Params, images: Data) {
        self.identifier = identifier
        self.params = params
        self.images = images
    }
    
    private var url: URL? {
        return URL(string: baseURLString)
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
