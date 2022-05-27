//
//  ProductListUseCase.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/25.
//

import Foundation
import UIKit

struct ProductListUseCase {
    
    private let network: NetworkAble = Network()
    private let jsonDecoder = JSONDecoder()
    private let pageInforManager = PageInfoManager()
    
    @discardableResult
    func requestPageInformation(
        completeHandler: @escaping (PageInformation) -> Void,
        decodingErrorHandler: @escaping (Error) -> Void
    ) -> URLSessionDataTask? {
        guard let url = pageInforManager.currentPageInformationUrl else {
            decodingErrorHandler(NetworkError.urlError)
            return nil
        }
        
        let dataTask = network.requestData(url: url) {
            data, urlResponse -> Void in
            guard let data = data,
                  let dcodedData = try? jsonDecoder.decode(PageInformation.self, from: data) else {
                decodingErrorHandler(NetworkError.decodingError)
                return
            }
            completeHandler(dcodedData)
        } errorHandler: { error in
            decodingErrorHandler(error)
        }
        return dataTask
    }
    
    @discardableResult
    func registerProduct(
        registrationParameter: RegistrationParameter,
        images: [UIImage],
        completeHandler: @escaping () -> Void,
        registerErrorHandler: @escaping (Error) -> Void
    ) -> URLSessionDataTask? {
        guard let url = OpenMarketApi.productRegister.url else {
            return nil
        }
        
        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue(Secret.registerIdentifier, forHTTPHeaderField: "identifier")
        
        var data = Data()
        let boundaryPrefix = "\r\n--\(boundary)\r\n"
        data.appendString(boundaryPrefix)
        data.appendString("Content-Disposition: form-data; name=\"params\"\r\n\r\n")
        data.appendString("""
        {
        \"name\": \"\(registrationParameter.name)\",
        \"price\": \"\(registrationParameter.price)\",
        \"currency\": \"\(registrationParameter.currency.rawValue)\",
        \"secret\": \"\(registrationParameter.secret)\",
        \"descriptions\": \"\(registrationParameter.descriptions)\",
        \"stock\": \"\(registrationParameter.stock)\",
        \"discounted_price\": \"\(registrationParameter.discountedPrice)\"
        }
        """)
        
        for image in images {
            data.appendString(boundaryPrefix)
            data.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"\(registrationParameter.name).jpeg\"\r\n")
            data.appendString("Content-Type: image/jpeg\r\n\r\n")
            guard let imageData = image.jpegData(compressionQuality: 0.1) else {
                return nil
            }
            data.append(imageData)
        }
        data.appendString("\r\n--\(boundary)--\r\n")
        
        request.httpBody = data
        
        let dataTask = network.requestData(urlRequest: request) { data, response in
            completeHandler()
        } errorHandler: { error in
            registerErrorHandler(error)
        }
        return dataTask
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
