//
//  ProductRegisterUseCase.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/30.
//

import UIKit

struct ProductRegisterUseCase {
    private let network: NetworkAble
    private let jsonEncoder: JSONEncoder

    init(network: NetworkAble, jsonEncoder: JSONEncoder){
        self.network = network
        self.jsonEncoder = jsonEncoder
    }

    @discardableResult
    func registerProduct(
        registrationParameter: RegistrationParameter,
        images: [UIImage],
        completeHandler: @escaping () -> Void,
        registerErrorHandler: @escaping (Error) -> Void
    ) -> URLSessionDataTask? {
        
        if let checkValidation = checkValidation(registrationParameter: registrationParameter) {
            registerErrorHandler(checkValidation)
            return nil
        }
        
        guard let url = OpenMarketApi.productRegister.url else {
            registerErrorHandler(NetworkError.urlError)
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
        
        guard let params = try? jsonEncoder.encode(registrationParameter) else { return nil }
        guard let paramsData = String(data: params, encoding: .utf8) else { return nil }
        data.appendString(paramsData)
        
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
    
    func checkValidation(registrationParameter parameter: RegistrationParameter) -> UseCaseError? {
        guard parameter.name.count < 3 else {
            return UseCaseError.nameError
        }
        guard parameter.descriptions.count < 1000 else {
            return UseCaseError.descriptionsError
        }
        guard parameter.price >= 0 else {
            return UseCaseError.priceError
        }
        guard parameter.discountedPrice <= parameter.price && parameter.discountedPrice >= 0 else {
            return UseCaseError.discountedPriceError
        }
        guard parameter.stock >= 0 else {
            return UseCaseError.stockError
        }
        return nil
    }
}

