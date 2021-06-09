//
//  URLProcess.swift
//  OpenMarket
//
//  Created by 김민성 on 2021/06/04.
//

import Foundation

class GETProcess {
    private let commonURLProcess: URLProcessUsable
    private let urlSession: URLSession

    init(commonURLProcess: URLProcessUsable, urlSession: URLSession = .shared) {
        self.commonURLProcess = commonURLProcess
        self.urlSession = urlSession
    }
    
    func dataParsing<T: Decodable>(index: String?, completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        let url = commonURLProcess.completedURL(model: T.self, urlMethod: "GET", index: index)

        urlSession.dataTask(with: url.url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...399).contains(response.statusCode) else {
                completionHandler(.failure(OpenMarketErrors.unknownError))
                return
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
