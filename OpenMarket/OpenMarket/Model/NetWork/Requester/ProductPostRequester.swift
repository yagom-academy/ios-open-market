import Foundation
import UIKit

struct ProductPostRequester: APIRequestable, MultiPartable {
    
    var url: URL? {
        return URL(string: "https://market-training.yagom-academy.kr/api/products")
    }
    var httpMethod: HTTPMethod = .POST
    var httpBody: Data? = nil
    var headerFields: [String: String]?
    var identifier: String {
        return "2aaf52b6-7217-11ec-abfa-8dc96101832e"
    }
    var boundary: String = "\(UUID().uuidString)"
    private let params: ProductPost.Request.Params
    let images: [UIImage]
    
    init(params: ProductPost.Request.Params, images: [UIImage]) {
        self.params = params
        self.images = images
        self.headerFields = ["Content-Type":"multipart/form-data; boundary=\(boundary)", "identifier": "\(identifier)"]
    }
}

 
