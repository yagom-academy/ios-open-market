//
//  URLSession.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/12.
//

import Foundation
import UIKit

class NetworkManager {
    private let session: URLSession
    init() {
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
        
        // params 설정
        data.append(startBoundaryData)
        guard let paramsAttribute = "Content-Disposition: form-data; name=\"params\"\r\n\r\n".data(using: .utf8) else {
            return nil
        }
        data.append(paramsAttribute)
        data.append(paramData)
        
        // images 설정
        for (index, image) in images.enumerated() {
            data.append(startBoundaryData)
            let fileName = "\(inputData.name) - \(index)"
            data.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(fileName).png\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append((image.jpegData(compressionQuality: 0.2))!)
        }
        
        guard let endBoundaryData = "\r\n--\(boundary)--\r\n".data(using: .utf8) else {
            return nil
        }
        data.append(endBoundaryData)
        return data
    }
}
