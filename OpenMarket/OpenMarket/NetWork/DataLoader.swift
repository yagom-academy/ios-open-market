//
//  URLProcess.swift
//  OpenMarket
//
//  Created by 김민성 on 2021/06/04.
//

import Foundation

class DataLoader {
    private let commonURLProcess: CommonURLProcess
    private let urlSession: URLSession

    init(commonURLProcess: CommonURLProcess, urlSession: URLSession = .shared) {
        self.commonURLProcess = commonURLProcess
        self.urlSession = urlSession
    }
    
    func startLoad<T: Decodable>(index: String?, completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        let url = commonURLProcess.completedURL(model: T.self, urlMethod: HttpMethod.get.rawValue, index: index)

        urlSession.dataTask(with: url.url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                return
            }
           
            guard let receivedResponse = response as? HTTPURLResponse else { return }
            
            guard (200...399).contains(receivedResponse.statusCode) else {
                if (400...499).contains(receivedResponse.statusCode) {
                    completionHandler(.failure(HttpCommunicationError.requestError(receivedResponse.statusCode)))
                    return
                } else if (500...599).contains(receivedResponse.statusCode) {
                    completionHandler(.failure(HttpCommunicationError.serverError(receivedResponse.statusCode)))
                    return
                } else {
                    completionHandler(.failure(HttpCommunicationError.unknownError))
                    return
                }
            }
            
            guard let resultData = data else { return }
            
            guard let decodedData = self.decodeDate(type: T.self, data: resultData) else { return }
            
            completionHandler(.success(decodedData))
        }.resume()
    }
    
    private func decodeDate<T: Decodable>(type: T.Type, data: Data) -> T? {
        do {
            let decoder = JSONDecoder()
            let parsingData = try decoder.decode(type, from: data)
            
            return parsingData
        } catch {
            print(error)
            return nil
        }
    }
}
