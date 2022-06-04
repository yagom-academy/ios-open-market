//
//  ProductDetailUseCase.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/06/03.
//

import Foundation

struct ProductDetailUseCase {
    private let network: NetworkAble
    private let jsonDecoder: JSONDecoder

    init(network: Network, jsonDecoder: JSONDecoder) {
        self.network = network
        self.jsonDecoder = jsonDecoder
    }
    
    func requestProductDetailInformation(
        id: Int,
        completeHandler: @escaping (ProductDetail) -> Void,
        errorHandler: @escaping (Error) -> Void
    ) {
        guard let url = OpenMarketApi.productDetail(productNumber: id).url else {
            errorHandler(NetworkError.urlError)
            return
        }
        
        network.requestData(url) { data, response in
            guard let decodedData = try? jsonDecoder.decode(ProductDetail.self, from: data) else {
                errorHandler(UseCaseError.decodingError)
                return
            }
            completeHandler(decodedData)
        } errorHandler: { error in
            errorHandler(error)
        }
    }
}
