import Foundation
import UIKit

extension URLRequest {
    init(url: URL, api: OpenMarketAPI) {
        self.init(url: url)
        
        self.httpMethod = api.httpMethod
        
        switch api {
        case .productDetail, .productList:
            return
        case .productRegister(let body, let id), .productUpdate(let body, let id), .productSecret(let body, let id):
            self.addValue(id, forHTTPHeaderField: "identifier")
            self.httpBody = body
        case .deleteProduct(let id):
            self.addValue(id, forHTTPHeaderField: "identifier")
        }
    }
}


