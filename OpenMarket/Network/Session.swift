//
//  Session.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/17.
//

import UIKit

struct Session: Http, Coder {
    
    func getItems(
        pageIndex: UInt,
        completionHandler: @escaping (Result<ItemList, HttpError>) -> Void
    ) {
        let path = HttpConfig.baseURL + HttpMethod.items.path
        
        guard let url = URL(string: path + pageIndex.description) else {
            return
        }
        
        doTaskWith(url: url) { result in
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
        
        doTaskWith(url: url) { result in
            completionHandler(result)
        }
    }
    
    func postItem(
        item: ItemRequestable,
        images: [UIImage],
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) {
       guard let request = buildedRequestWithFormDataAbout(
                method: HttpMethod.post,
                item: item,
                images: images
       ) else { return }
        
        doTaskWith(request: request) { result in
            completionHandler(result)
        }
    }
    
    func patchItem(
        itemId: Int,
        item: ItemRequestable? = nil,
        images: [UIImage]? = nil,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) {
       guard let request = buildedRequestWithFormDataAbout(
                method: HttpMethod.patch(id: itemId.description),
                item: item,
                images: images
       ) else { return }
        
        doTaskWith(request: request) { result in
            completionHandler(result)
        }
    }

    func deleteItem(
        itemId: Int,
        item: ItemRequestable,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) {
        guard let request = buildedRequestWithJSONAbout(
                method: .delete(id: itemId.description),
                item: item
        ) else {
            return
        }
        
        doTaskWith(request: request) { result in
            completionHandler(result)
        }
    }
}

extension Session {
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
    
    private func doTaskWith<Model>(
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
                
                let parsedData = parse(from: data, to: Model.self, or: HttpError.self)
                completionHandler(parsedData)
            }
            .resume()
    }
    
    private func doTaskWith<Model>(
        request: URLRequest,
        completionHandler: @escaping (Result<Model, HttpError>) -> Void
    ) where Model: Decodable {
        URLSession.shared
            .dataTask(with: request) { data, response, error in
                guard let data = guardedDataAbout(data: data, response: response, error: error) else {
                    let error = HttpError(message: HttpConfig.unknownError)
                    completionHandler(.failure(error))
                    return
                }
                
                let parsedData = parse(from: data, to: Model.self, or: HttpError.self)
                completionHandler(parsedData)
            }
            .resume()
    }
    
    private func buildedRequestWithFormDataAbout<Model>(
        method: HttpMethod,
        item: Model? = nil,
        images: [UIImage]? = nil
    ) -> URLRequest? where Model: Loopable {
        
        let path = HttpConfig.baseURL + method.path
        
        guard let url = URL(string: path) else {
            return nil
        }
        
        let boundary = HttpConfig.boundary
        var request = URLRequest(url: url)
        
        request.httpMethod = method.type
        request.setValue(HttpConfig.requestHeader + boundary, forHTTPHeaderField: HttpConfig.contentType)
        
        let boundaryWithPrefix = HttpConfig.boundaryPrefix + boundary
        
        if let images = images {
            var imageDatas = [Data]()
            
            for image in images {
                guard let jpegData = image.jpegData(compressionQuality: 1) else {
                    continue
                }
                
                imageDatas.append(jpegData)
            }
            
            request.httpBody = buildedFormData(from: imageDatas, boundary: boundaryWithPrefix)
        } else {
            request.httpBody = Data()
        }
        
        if let item = item {
            let itemData = buildedFormData(from: item, boundary: boundaryWithPrefix)
            
            request.httpBody?.append(itemData)
        }
        
        return request
    }
    
    private func buildedRequestWithJSONAbout<Model>(
        method: HttpMethod,
        item: Model
    ) -> URLRequest? where Model: Encodable {
        let path = HttpConfig.baseURL + method.path
        guard let url = URL(string: path),
              let body = try? encode(from: item, or: HttpError.self).get() else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: HttpConfig.contentType)
        request.httpMethod = method.type
        request.httpBody = body
        return request
    }
    
    private func buildedFormData<Model>(
        from model: Model,
        boundary: String
    ) -> Data where Model: Loopable {
        
        var form = ""
        
        for (key, value) in model.properties {
            guard let value = value else { continue }
            
            form += boundary + .newLine
            form += "Content-Disposition: form-data; "
            form += "name=\"\(key)\"" + .newLine + .newLine
            form += "\(String(describing: value))" + .newLine
        }
        
        form += boundary +  "--"
        
        return form.data(using: .utf8) ?? Data()
    }
    
    private func buildedFormData(
        from datas: [Data],
        boundary: String
    ) -> Data {
        var form = Data()
        
        for data in datas {
            form += (boundary + .newLine).utf8
            form += "Content-Disposition: form-data; name=\"images[]\"".utf8
            form += (.newLine + "Content-Type: image/jpeg").utf8
            form += (.newLine + .newLine).utf8
            form += data + String.newLine.utf8
        }
        
        return form
    }
}
