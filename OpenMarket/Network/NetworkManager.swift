//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/24.
//

import Foundation
import UIKit

class NetworkManager {
    
    static var shared = NetworkManager()
    var isPaginating = false
    let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func getItemsOfPageData(pagination: Bool, pageNumber: Int, completion: @escaping (Data?, Int?)->(Void))  {
        if pagination {
            isPaginating = true
        }
        guard let url = URL(string: Network.baseURL + "/items/\(pageNumber)") else { return  }
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            self?.checkValidation(data: data, response: response, error: error)
            if pagination {
                self?.isPaginating = false
            }
            completion(data, pageNumber)
        }.resume()
    }
    
    private func checkValidation(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            fatalError("\(error)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid Response")
            return
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("Status Code: \(httpResponse.statusCode)")
            return
        }
        
        guard let _ = data else {
            print("Invalid Data")
            return
        }
    }
    
    //    func postItem(requestData: Request, completion: @escaping (Data?)->(Void)){
    //
    //        guard let url = URL(string: Network.baseURL + "/item") else { return }
    //
    //        var request = URLRequest(url: url)
    //        let boundary = generateBoundary()
    //        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    //        request.httpMethod = HTTPMethod.POST.rawValue
    //        request.httpBody = encodedData(data: requestData)
    //
    //        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
    //            self?.checkValidation(data: data, response: response, error: error)
    //            print("data : ",data)
    //            print("response : ",response)
    //            print("error : ",error)
    //            completion(data)
    //        }.resume()
    //
    //    }
    //    func encodedData(data: Request) -> Data? {
    //        let encoder = JSONEncoder()
    //        return try? encoder.encode(data)
    //    }
    
    func classifyKeyValue(model: Request) -> Parameters {
        guard let title = model.title else { return [:] }
        guard let descriptions = model.descriptions else { return [:] }
        guard let price = model.price else { return [:] }
        guard let currency = model.currency else { return [:] }
        guard let stock = model.stock else { return [:] }
        guard let discountedPrice = model.discountedPrice else { return [:] }
        guard let password = model.password else { return [:] }
        
        return ["title": "\(title)",
                "descriptions": "\(descriptions)",
                "price":"\(price)",
                "currency":"\(currency)",
                "stock":"\(stock)",
                "discounted_price":"\(discountedPrice)",
                "password":"\(password)" ]
    }
    
    func setUpImage(model: Request) -> [ItemImage] {
        var images: [ItemImage] = []
        guard let requestedImages = model.images else { return [] }
        for image in requestedImages {
            guard let uiImage = UIImage(named: image) else { return [] }
            guard let itemImage = ItemImage(withImage: uiImage, forKey: "images[]", fileName: image) else { return [] }
            images.append(itemImage)
        }
        return images
    }
    
    func postItem(requestData: Request, completion: @escaping (Data?)->(Void)){
       
        guard let mediaImage = ItemImage(withImage: UIImage(named: "clear")!, forKey: "images[]",fileName: "clear") else { return }
        print(classifyKeyValue(model: requestData))
        print(setUpImage(model: requestData))
        guard let url = URL(string: Network.baseURL + "/item") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let dataBody = createDataBody(withParameters: classifyKeyValue(model: requestData), itemImages: setUpImage(model: requestData), boundary: boundary)
        request.httpBody = dataBody
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            completion(data)
        }.resume()
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: Parameters?, itemImages: [ItemImage]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let itemImages = itemImages {
            for photo in itemImages {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)//?
        }
    }
}

typealias Parameters = [String: String]

struct ItemImage {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String, fileName: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.fileName = fileName + ".jpg"
        
        guard let jpgData = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = jpgData
    }
    
}
