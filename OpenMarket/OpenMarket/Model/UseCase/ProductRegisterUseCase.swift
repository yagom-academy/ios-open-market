//
//  ProductRegisterUseCase.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/30.
//

import UIKit

struct ProductRegisterUseCase {
    
    private enum Constant {
        static let defaultCurrency = Currency.KRW.rawValue
        static let priceDefaultValue: Double = 0
        static let discounteDefaultValue: Double = 0
        static let stockDefaultValue = 0
    }
    
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
        completeHandler: @escaping (Data, URLResponse) -> Void,
        errorHandler: @escaping (Error) -> Void
    ) -> URLSessionDataTask? {
        do {
            var copyRegistrationParameter = registrationParameter
            if let checkValidation = checkValidation(registrationParameter: &copyRegistrationParameter) {
                errorHandler(checkValidation)
                return nil
            }
            let request = try OpenMarketApi.productRegister(registrationParameter: copyRegistrationParameter, images: images).makeRequest()
            let dataTask = network.requestData(request) { data, response in
                completeHandler(data, response)
            } errorHandler: { error in
                errorHandler(error)
            }
            return dataTask
        } catch {
            errorHandler(error)
            return nil
        }
    }
    
    func checkValidation(registrationParameter parameter: inout RegistrationParameter) -> UseCaseError? {
        guard let name = parameter.name, name.count > 3 else {
            return UseCaseError.nameError
        }
        guard let descriptions = parameter.descriptions, descriptions.count < 1000 else {
            return UseCaseError.descriptionsError
        }
        
        if let price = parameter.price {
            if price < 0 {
                return UseCaseError.priceError
            }
        } else {
            parameter.changeValue(price: Constant.priceDefaultValue)
        }
        
        if let discountedPrice = parameter.discountedPrice {
            if discountedPrice < 0 {
                return UseCaseError.discountedPriceError
            }
        } else {
            parameter.changeValue(discountedPrice: Constant.discounteDefaultValue)
        }
        
        guard parameter.stock ?? 0 >= 0 else {
            return UseCaseError.stockError
        }
        
        return nil
    }
}
