//
//  GetEssentilaArticle.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/14.
//

import Foundation

class GetEssentialArticle {
    
    private let urlProcess: URLProcessUsable
    private let session: URLSession
    
    init(urlProcess: URLProcessUsable, session: URLSession = URLSession.shared) {
        self.urlProcess = urlProcess
        self.session = session
    }
    
    func getParsing<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            if error != nil { return }

            guard let response = response as? HTTPURLResponse,
                  (200...399).contains(response.statusCode) else {
                completion(.failure(error ?? OpenMarketError.unknownError))
                return
            }
            
            guard let resultData = data else { return }
            guard let final = self.decodeData(type: T.self, data: resultData) else { return }
                
            completion(.success(final))
        }.resume()
    }
    
    func decodeData<T: Decodable>(type: T.Type, data: Data) -> T? {
        do {
            let decoder = JSONDecoder()
            let parsingData = try decoder.decode(type, from: data)

            return parsingData
        } catch {
            return nil
        }
    }
    
}
