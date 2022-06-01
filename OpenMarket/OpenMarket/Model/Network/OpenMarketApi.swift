//
//  ApiUrl.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/11.
//

import UIKit

enum OpenMarketApi {
    
    private static let hostUrl = "https://market-training.yagom-academy.kr/"
    
    case pageInformation(pageNo: Int, itemsPerPage: Int)
    case productDetail(productNumber: Int)
    case productRegister(registrationParameter: RegistrationParameter, images: [UIImage])
    
    private var urlString: String {
        switch self {
        case .pageInformation(let pageNo, let itemsPerPage):
            return Self.hostUrl + "api/products?page_no=\(pageNo)&items_per_page=\(itemsPerPage)"
        case .productDetail(let productNumber):
            return Self.hostUrl + "api/products/\(productNumber)"
        case .productRegister:
            return Self.hostUrl + "api/products"
        }
    }
    
    var url: URL? {
            let urlComponents = URLComponents(string: self.urlString)
            return urlComponents?.url
    }
    
    func makeRequest() throws -> URLRequest {
        
        guard let url = self.url else {
            throw(NetworkError.urlError)
        }
        
        var request = URLRequest(url: url)
        
        switch self {
        case .pageInformation(_, _):
            request.httpMethod = "GET"
            return request
        case .productDetail(let productNumber):
            //추후 구현 예정
            throw(NetworkError.urlError)
        case .productRegister(let registrationParameter, let images):
            
            let boundary = UUID().uuidString
            let boundaryPrefix = "\r\n--\(boundary)\r\n"
            let jsonEncoder = JSONEncoder()
            
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.addValue(Secret.registerIdentifier, forHTTPHeaderField: "identifier")
            
            var data = Data()
            
            data.appendString(boundaryPrefix)
            data.appendString("Content-Disposition: form-data; name=\"params\"\r\n\r\n")
            
            guard let params = try? jsonEncoder.encode(registrationParameter) else {
                throw(UseCaseError.encodingError)
            }
            
            guard let paramsData = String(data: params, encoding: .utf8) else {
                throw(UseCaseError.encodingError)
            }
            
            data.appendString(paramsData)
            let imageEncoder = ImageEncoder()
            
            for image in images {
                data.appendString(boundaryPrefix)
                data.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"\(registrationParameter.name).jpeg\"\r\n")
                data.appendString("Content-Type: image/jpeg\r\n\r\n")
                let imageData = try imageEncoder.encodeImage(image: image)
                
                data.append(imageData)
            }
            data.appendString("\r\n--\(boundary)--\r\n")
            request.httpBody = data
        }
        return request
    }

}
