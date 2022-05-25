//
//  ProductListUseCase.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/25.
//

import Foundation

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
}
