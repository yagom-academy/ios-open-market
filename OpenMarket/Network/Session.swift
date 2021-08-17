//
//  Session.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/17.
//

import Foundation

struct Session: Http, Decoder {
    
    func getItems(
        pageIndex: UInt,
        completionHandler: @escaping (Result<ItemList, HttpError>) -> Void
    ) {
        let path = HttpConfig.baseURL + HttpMethod.items.path
        
        guard let url = URL(string: path + pageIndex.description) else {
            let error = HttpError(message: HttpConfig.unknownError)
            completionHandler(.failure(error))
            return
        }
        
        URLSession.shared
            .dataTask(with: url) { data, response, error in
                guard let data = guardedDataAbout(data: data, response: response, error: error) else {
                    return
                }
                
                
                let parsedData = parse(from: data, to: ItemList.self)
                completionHandler(parsedData)
            }
            .resume()
    }
    
    func getItem(
        id: UInt,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) {
        let path = HttpConfig.baseURL + HttpMethod.item.path
        
        guard let url = URL(string: path + id.description) else {
            return
        }
        
        URLSession.shared
            .dataTask(with: url) { data, response, error in
                guard let data = guardedDataAbout(data: data, response: response, error: error) else {
                    let error = HttpError(message: HttpConfig.unknownError)
                    completionHandler(.failure(error))
                    return
                }
                
                let parsedData = parse(from: data, to: ItemDetail.self)
                completionHandler(parsedData)
            }
            .resume()
    }

    private func buildedFormData() -> String {
        return ""
    }
    
    private func guardedDataAbout(
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) -> Data? {
        if let _ = error {
            return nil
        }
        
        guard let data = data else {
            return nil
        }
        
        return data
    }
}
