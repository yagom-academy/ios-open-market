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
        errorHandler: @escaping (Error) -> Void
    ) -> URLSessionDataTask? {
        do {
            if let checkValidation = checkValidation(registrationParameter: registrationParameter) {
                errorHandler(checkValidation)
                return nil
            }
            let request = try OpenMarketApi.productRegister(registrationParameter: registrationParameter, images: images).makeRequest()
            let dataTask = network.requestData(request) { data, response in
                completeHandler()
            } errorHandler: { error in
                errorHandler(error)
            }
            return dataTask
        } catch {
            errorHandler(error)
            return nil
        }
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
