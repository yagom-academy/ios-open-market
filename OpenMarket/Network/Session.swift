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
            return
        }
        
        getTask(url: url) { result in
            completionHandler(result)
        }
    }
    
    func getItem(
        id: UInt,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) {
        let path = HttpConfig.baseURL + HttpMethod.item.path
        
        guard let url = URL(string: path + id.description) else {
            return
        }
        
        getTask(url: url) { result in
            completionHandler(result)
        }
    }
    

    func buildedFormData<Model>(
        from model: Model,
        boundary: String
    ) -> Data where Model: Loopable {
        
        var form = ""
        
        for (key, value) in model.properties {
            guard let value = value else { continue }
            
            form += boundary + .newLine
            form += "Content-Disposition: form-data;"
            form += "name=\"\(key)" + .newLine + .newLine
            form += "\(String(describing: value))" + .newLine
        }
        
        form += boundary +  "--"
        
        return form.data(using: .utf8)!
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
    
    private func getTask<Model>(
        url: URL,
        completionHandler: @escaping (Result<Model, HttpError>) -> Void
    ) where Model: Decodable {
        URLSession.shared
            .dataTask(with: url) { data, response, error in
                guard let data = guardedDataAbout(data: data, response: response, error: error) else {
                    let error = HttpError(message: HttpConfig.unknownError)
                    completionHandler(.failure(error))
                    return
                }
                
                
                let parsedData = parse(from: data, to: Model.self)
                completionHandler(parsedData)
            }
            .resume()
    }
}
