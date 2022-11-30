//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/30.
//

import UIKit.UIImage

protocol BodyParameterItem {
    var data: Data { get }
}

struct BodyParameter {
    let key: String
    let item: BodyParameterItem
}

enum Image {
    case jpeg(image: UIImage)
    case png(image: UIImage)
    
    var type: String {
        switch self {
        case .jpeg(_):
            return "image/jpeg"
        case .png(_):
            return "image/png"
        }
    }
    
    var data: Data? {
        switch self {
        case .jpeg(let image):
            return image.jpegData(compressionQuality: 1.0)
        case .png(let image):
            return image.pngData()
        }
    }
}

struct ImageDataContainer: BodyParameterItem {
    let name: String = UUID().uuidString
    let data: Data
    let contentType: String
    
    init?(image: Image) {
        guard let imageData: Data = image.data else {
            return nil
        }
        self.data = imageData
        self.contentType = image.type
    }
}

struct JSONDataContainer: BodyParameterItem {
    let data: Data
}

struct NetworkManager: Requestable {
    let path: String
    let method: HttpMethod
    var headers: [String : String] = ["identifier": "ecae4d3d-6941-11ed-a917-59a39ea07e01"]
    var bodyParameters: [BodyParameter]? = []
    
    mutating func session(boundary: String = UUID().uuidString) {
        var request: URLRequest = URLRequest(url: URL(string: "https://openmarket.yagom-academy.kr/api/products")!)
        headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        headers.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        request.httpMethod = HttpMethod.post.text
        request.httpBody = makeBody(boundary)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            print(String(data: data!, encoding: .utf8))
        }.resume()
    }
    
    private func makeBody(_ boundary: String) -> Data {
        var body: Data = Data()
        
        bodyParameters?.forEach { parameter in
            body.append("--\(boundary)\r\n")
            if let imageDataContainer = parameter.item as? ImageDataContainer {
                body.append("Content-Disposition: form-data; name=\"\(parameter.key)\"; filename=\"\(imageDataContainer.name)\"\r\n")
                body.append("Content-Type: \(imageDataContainer.contentType)")
            } else {
                body.append("Content-Disposition: form-data; name=\"\(parameter.key)\"")
            }
            body.append("\r\n\r\n")
            body.append(parameter.item.data)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--")
        
        return body
    }
}

extension Data {
    mutating public func append(_ newElement: String) {
        if let newData: Data = newElement.data(using: .utf8) {
            self.append(newData)
        }
    }
}
