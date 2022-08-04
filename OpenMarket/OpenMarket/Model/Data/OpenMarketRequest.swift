//
//  OpenMarketRequest.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/19.
//

import Foundation
import UIKit

struct OpenMarketRequest: APIRequest {
    var body: Data?
    var path: String? = URLAdditionalPath.product.value
    var method: HTTPMethod = .get
    var baseURL: String = URLHost.openMarket.url
    var headers: [String : String]?
    var query: [String: String]?
}

enum HTTPHeaders {
    var boundary: String {
        "Boundary-\(UUID().uuidString)"
    }
    
    case json
    case multipartFormData
    
    var name: [String: String] {
        switch self {
        case .json:
            return ["identifier": "eef3d2e5-0335-11ed-9676-e35db3a6c61a",
                    "Content-Type": "application/json"]
        case .multipartFormData:
            return ["identifier": "eef3d2e5-0335-11ed-9676-e35db3a6c61a",
                    "Content-Type": "multipart/form-data; boundary=\(boundary)"]
        }
    }
}

extension OpenMarketRequest {
    mutating func setPostRequest(images: [Data], productData: Data) -> APIRequest {
        let boundary = "Boundary-\(UUID().uuidString)"
        self.body = createMultiPartFormBody(boundary: boundary, paramsData: productData, images: images)
        self.method = .post
        self.headers = HTTPHeaders.multipartFormData.name
        
        return self
    }
    
    mutating func setPatchRequest(productId: String, productData: Data) -> APIRequest {
        self.body = productData
        self.path = (self.path ?? "") + "/\(productId)/"
        self.method = .patch
        self.headers = HTTPHeaders.json.name
        
        return self
    }
    
    mutating func SetGetProductListsRequest() -> APIRequest {
        self.query =
        [
            Product.page.text:  "\(Product.page.number)",
            Product.itemPerPage.text: "\(Product.itemPerPage.number)"
        ]
    
        return self
    }
    
    mutating func SetGetImageRequest() -> APIRequest {
        self.path = nil
    
        return self
    }
}

extension UIImage {
    func resize(width: CGFloat) -> UIImage {
        let scale = width / self.size.width
        let newHeight = self.size.height * scale
        
        let size = CGSize(width: width, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        var renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        let imgData = NSData(data: renderImage.pngData()!)
        let imageSize = Double(imgData.count) / 1000
        
        if imageSize > 300 {
            renderImage = resize(width: width - 5)
        }
        return renderImage
    }
}
