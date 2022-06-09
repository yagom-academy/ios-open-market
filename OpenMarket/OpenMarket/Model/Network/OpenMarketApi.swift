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
            let dataEncoder = DataEncoder(boundary: boundary)
            
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.addValue(Secret.registerIdentifier, forHTTPHeaderField: "identifier")
            
            var data = try dataEncoder.encodeFormData(parameter: registrationParameter)
            let imageData = try dataEncoder.encodeImages(images: images)
            data.append(imageData)
            request.httpBody = data
        }
        return request
    }
}
