//
//  Session.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/17.
//

import UIKit

struct NetworkManager: API {
    
    func getGoodsList(
        pageIndex: UInt,
        completionHandler: @escaping (Result<GoodsList, HttpError>) -> Void
    ) throws {
        let currentMethod = HttpMethod.items(pageIndex: pageIndex)
        guard let request = buildedBasicRequest(method: currentMethod) else {
            throw HttpError.Case.requestBuildingFailed
        }
        
        doTaskWith(request: request) { result in
            completionHandler(result)
        }
    }
    
    func getGoods(
        id: UInt,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) throws {
        let currentMethod = HttpMethod.item(id: id.description)
        guard let request = buildedBasicRequest(method: currentMethod) else {
            throw HttpError.Case.requestBuildingFailed
        }
        
        doTaskWith(request: request) { result in
            completionHandler(result)
        }
    }
    
    func postGoods(
        item: ItemRequestable,
        images: [UIImage],
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) throws {
       guard let request = buildedRequestWithFormData(
                about: HttpMethod.post,
                item: item,
                images: images
       ) else {
            throw HttpError.Case.requestBuildingFailed
       }
        
        doTaskWith(request: request) { result in
            completionHandler(result)
        }
    }
    
    func patchGoods(
        id: Int,
        item: ItemRequestable,
        images: [UIImage]? = nil,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) throws {
       guard let request = buildedRequestWithFormData(
                about: HttpMethod.patch(id: id.description),
                item: item,
                images: images
       ) else {
            throw HttpError.Case.requestBuildingFailed
       }
        
        doTaskWith(request: request) { result in
            completionHandler(result)
        }
    }

    func deleteGoods(
        id: Int,
        item: ItemRequestable,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) throws {
        guard let request = buildedRequestWithJSON(
                about: .delete(id: id.description),
                item: item
        ) else {
            throw HttpError.Case.requestBuildingFailed
        }
        
        doTaskWith(request: request) { result in
            completionHandler(result)
        }
    }
}

extension NetworkManager {
    private func buildedBasicRequest(method: HttpMethod) -> URLRequest? {
        guard let url = URLGenerator.generate(from: method) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.type
        
        return request
    }
    
    private func guardedDataAbout(
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) -> Data? {
        guard let data = data else {
            return nil
        }
        
        return data
    }
    
    private func doTaskWith<Model>(
        request: URLRequest,
        completionHandler: @escaping (Result<Model, HttpError>) -> Void
    ) where Model: Decodable {
        URLSession.shared
            .dataTask(with: request) { data, response, error in
                guard let data = guardedDataAbout(data: data, response: response, error: error) else {
                    let error = HttpError(message: HttpError.Case.unknownError.errorDescription)
                    completionHandler(.failure(error))
                    return
                }
                
                let parsedData = Parser.decode(from: data, to: Model.self, or: HttpError.self)
                completionHandler(parsedData)
            }
            .resume()
    }
    
    private func buildedRequestWithFormData<Model>(
        about method: HttpMethod,
        item: Model? = nil,
        images: [UIImage]? = nil
    ) -> URLRequest? where Model: Loopable {
        guard var request = buildedBasicRequest(method: method) else {
            return nil
        }
        
        let boundary = HttpConfig.boundary
        
        request.setValue(HttpConfig.multipartFormData + boundary, forHTTPHeaderField: HttpConfig.contentType)
        
        let boundaryWithPrefix = HttpConfig.boundaryPrefix + boundary
        
        if let images = images {
            request.httpBody = images.buildedFormData(boundary: boundaryWithPrefix)
        } else {
            request.httpBody = Data()
        }
        
        if let item = item {
            let itemData = item.buildedFormData(boundary: boundaryWithPrefix)
            
            request.httpBody?.append(itemData)
        }
        
        return request
    }
    
    private func buildedRequestWithJSON<Model>(
        about method: HttpMethod,
        item: Model
    ) -> URLRequest? where Model: Encodable {
        guard var request = buildedBasicRequest(method: method),
              let body = try? Parser.encode(from: item, or: HttpError.self).get() else {
            return nil
        }
        
        request.setValue(HttpConfig.applicationJson, forHTTPHeaderField: HttpConfig.contentType)
        request.httpMethod = method.type
        request.httpBody = body
        return request
    }
}
