//
//  NetworkLayer.swift
//  OpenMarket
//
//  Created by Zero DotOne on 2021/01/27.
//

import Foundation

struct NetworkLayer {
    private let httpRequest = HTTPRequest()
    
    func request(requestAPI: RequestAPI, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        guard let urlRequest = httpRequest.CreateURLRequest(requestAPI: requestAPI) else {
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(ItemList.self, from: data)
                    completionHandler(data, response, error)
                    print(decodedData)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func requestRegistration(requestAPI: RequestAPI, bodyData: ItemRegistrationRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        guard let urlRequest = httpRequest.CreateItemRegistrationURLRequest(requestAPI: requestAPI, bodyData: bodyData) else {
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(ItemRegistrationResponse.self, from: data)
                    completionHandler(data, response, error)
                    print(decodedData)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
