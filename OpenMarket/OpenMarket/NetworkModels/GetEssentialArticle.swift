//
//  GetEssentilaArticle.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/14.
//

import Foundation

class GetEssentialArticle {
    
    let urlProcess = URLProcess()
    
    func getParsing<T: Decodable>(url: URL, completion: @escaping (T) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil { return }

            if self.urlProcess.checkResponseCode(response: response) {
                guard let resultData = data else { return }
                guard let final = self.decodeData(type: T.self, data: resultData) else { return }
                completion(final)
            } else { return }
        }
        dataTask.resume()
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
