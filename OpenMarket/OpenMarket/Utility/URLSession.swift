//
//  URLSession.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/12.
//

import Foundation
import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession
    private init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    // MARK: - GET 상품 목록 조회
    func requestProductPage(at pageNumber: Int, _ completion: @escaping ([Product]) -> Void ) {
        var urlComponents = URLComponents(string: URLData.host + URLData.apiPath + "?")
        let pageNo = URLQueryItem(name: "page_no", value: String(pageNumber))
        let itemsPerPage = URLQueryItem(name: "items_per_page", value: "20")
        urlComponents?.queryItems?.append(pageNo)
        urlComponents?.queryItems?.append(itemsPerPage)
        guard let url = urlComponents?.url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.GET.rawValue
        let dataTask = createDataTask(request: request, type: ProductPage.self) { productPage in
            completion(productPage.pages)
        }
        dataTask.resume()
    }
    // MARK: - GET 상품 상세 조회
    func requestProductDetail(at id: Int, _ completion: @escaping (ProductDetail) -> Void ) {
        guard let url = URLComponents(string: URLData.host + URLData.apiPath + "/\(id)")?.url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.GET.rawValue
        let dataTask = createDataTask(request: request, type: ProductDetail.self) { detail in
            completion(detail)
        }
        dataTask.resume()
    }
    // MARK: - POST 상품 등록
    func requestProductRegistration(with registration: ProductRegistration, images: [UIImage] ,_ completion: @escaping (ProductDetail) -> Void) {
        guard let url = URL(string: URLData.host + URLData.apiPath) else {
            return
        }
        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.POST.rawValue
        request.setValue(URLData.identifier, forHTTPHeaderField: "identifier")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createPostBody(with: registration, images: images, at: boundary)
        let dataTask = createDataTask(request: request, type: ProductDetail.self) { detail in
            completion(detail)
        }
        dataTask.resume()
    }
    // MARK: - FETCH 상품 수정
    func requestProductModification(id: Int, rowData: String, _ completion: @escaping (ProductDetail) -> Void) {
        guard let url = URL(string: URLData.host + URLData.apiPath + "/\(id)") else {
            return
        }
        let parameters = rowData
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.httpBody = postData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(URLData.identifier, forHTTPHeaderField: "identifier")
        let dataTask = createDataTask(request: request, type: ProductDetail.self) { detail in
            completion(detail)
        }
        dataTask.resume()
    }
    // MARK: - DELETE 상품 삭제
    func requestProductDeleteKey(id: Int, _ completion: @escaping (String) -> Void) {
        guard let url = URL(string: URLData.host + URLData.apiPath + "/\(id)/secret") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.POST.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(URLData.identifier, forHTTPHeaderField: "identifier")
        request.httpBody = "{\"secret\": \"\(URLData.secret)\"}".data(using: .utf8)
        let dataTask = createDataTask(request: request, type: String.self) { deleteKey in
            completion(deleteKey)
        }
        dataTask.resume()
    }
    
    func requestProductDelete(id: Int, key: String) {
        guard let url = URL(string: URLData.host + URLData.apiPath + "/\(id)/\(key)") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.DELETE.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(URLData.identifier, forHTTPHeaderField: "identifier")
        let dataTask = createDataTask(request: request, type: ProductDetail.self) { detail in
            print("COMPL")
        }
        dataTask.resume()
    }
}

extension NetworkManager {
    private func createDataTask<T: Decodable>(request: URLRequest, type: T.Type, _ completion: @escaping (T) -> Void ) -> URLSessionDataTask {
        session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return
            }
            let successsRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successsRange.contains(statusCode) else {
                      return
                  }
            guard let resultData = data,
                  let fetchedData = decode(from: resultData, to: type.self) else {
                      debugPrint("ERROR: FAILURE DECODING ")
                      return
                  }
            completion(fetchedData)
        }
    }
    
    private func createPostBody(with inputData: ProductRegistration, images: [UIImage], at boundary: String) -> Data? {
        var data = Data()
        guard let paramData = try? JSONEncoder().encode(inputData) else {
            return nil
        }
        guard let startBoundaryData = "\r\n--\(boundary)\r\n".data(using: .utf8) else {
            return nil
        }
        data.append(startBoundaryData)
        guard let paramsAttribute = "Content-Disposition: form-data; name=\"params\"\r\n\r\n".data(using: .utf8) else {
            return nil
        }
        data.append(paramsAttribute)
        data.append(paramData)
        for (index, image) in images.enumerated() {
            data.append(startBoundaryData)
            let fileName = "\(inputData.name) - \(index)"
            data.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(fileName).png\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            guard let compressionImage = compress(image) else {
                return nil
            }
            data.append(compressionImage)
        }
        guard let endBoundaryData = "\r\n--\(boundary)--\r\n".data(using: .utf8) else {
            return nil
        }
        data.append(endBoundaryData)
        return data
    }
    
    func translateToRowData(_ data: ModificationData) -> String {
        var detailToModify = ["secret": nil, "name": nil, "descriptions": nil,
                              "thumbnail_id": nil, "price": nil, "currency": nil,
                              "discounted_price": nil, "stock": nil] as [String : Any?]
        detailToModify["secret"] = URLData.secret
        detailToModify["name"] = data.name
        detailToModify["descriptions"] = data.descriptions
        detailToModify["thumbnail_id"] = data.thumbnailId
        detailToModify["price"] = data.price
        detailToModify["currency"] = data.currency?.rawValue
        detailToModify["discounted_price"] = data.discountedPrice
        detailToModify["stock"] = data.stock
        
        var result: [String] = []
        for (key, value) in detailToModify {
            if value != nil {
                if value is String || value is Currency {
                    result.append("\"\(key)\": \"\(value!)\"")
                } else {
                    result.append("\"\(key)\": \(value!)")
                }
            }
        }
        return "{\(result.joined(separator: ","))}"
    }
    private func compress(_ Image: UIImage) -> Data? {
        guard var compressedImage = Image.jpegData(compressionQuality: 0.2) else {
            return nil
        }
        while compressedImage.count > 307200 {
            compressedImage = UIImage(data: compressedImage)?.jpegData(compressionQuality: 0.5) ?? Data()
        }
        return compressedImage
    }
}

