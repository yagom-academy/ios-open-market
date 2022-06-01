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
    
    private enum Constant {
        static let maximumImageSize = 300 * 1024
        static let resizeWidthValue: CGFloat = 100
        static let compressionQualityValue: CGFloat = 1
    }

    init(network: NetworkAble, jsonEncoder: JSONEncoder){
        self.network = network
        self.jsonEncoder = jsonEncoder
    }

    @discardableResult
    func registerProduct(
        registrationParameter: RegistrationParameter,
        images: [UIImage],
        completeHandler: @escaping () -> Void,
        errorHandler: @escaping (Error) -> Void
    ) -> URLSessionDataTask? {
        
        if let checkValidation = checkValidation(registrationParameter: registrationParameter) {
            errorHandler(checkValidation)
            return nil
        }
        
        guard let url = OpenMarketApi.productRegister.url else {
            errorHandler(NetworkError.urlError)
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
        
        guard let params = try? jsonEncoder.encode(registrationParameter) else {
            errorHandler(UseCaseError.encodingError)
            return nil
        }
        guard let paramsData = String(data: params, encoding: .utf8) else {
            errorHandler(UseCaseError.encodingError)
            return nil
        }
        data.appendString(paramsData)
        
        for image in images {
            data.appendString(boundaryPrefix)
            data.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"\(registrationParameter.name).jpeg\"\r\n")
            data.appendString("Content-Type: image/jpeg\r\n\r\n")
            
            var appendedData = Data()
            guard let imageData = image.jpegData(compressionQuality: Constant.compressionQualityValue) else {
                errorHandler(UseCaseError.imageError)
                return nil
            }
            appendedData = imageData
    
            if appendedData.count > Constant.maximumImageSize {
                let resizeValue = image.resize(newWidth: Constant.resizeWidthValue)
                guard let resizedImageData = resizeValue.jpegData(compressionQuality: Constant.compressionQualityValue),
                      resizedImageData.count < Constant.maximumImageSize else {
                    errorHandler(UseCaseError.imageError)
                    return nil
                }
                appendedData = resizedImageData
            }
            
            data.append(appendedData)
        }
        data.appendString("\r\n--\(boundary)--\r\n")
        
        request.httpBody = data
        
        let dataTask = network.requestData(urlRequest: request) { data, response in
            completeHandler()
        } errorHandler: { error in
            errorHandler(error)
        }
        return dataTask
    }
    
    func checkValidation(registrationParameter parameter: RegistrationParameter) -> UseCaseError? {
        guard parameter.name.count > 3 else {
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
