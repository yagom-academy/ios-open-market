//
//  GetEssentilaArticle.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/14.
//

import Foundation

class GetEssentialArticle {
    
    let urlProcess = URLProcess()
    
    func getParsing<T: Decodable>(completion: @escaping (T) -> Void) {
        guard let relativeURL = urlProcess.setURLPath(methodType: "GET", index: "5") else { return }

        let dataTask = URLSession.shared.dataTask(with: relativeURL) { (data, response, error) in
            if error != nil { return }

            if self.urlProcess.checkResponseCode(response: response) {
                guard let resultData = data else { return }
                let final = self.decodeData(type: T.self, data: resultData)
                completion(final!)
            } else { return }
        }
        dataTask.resume()
    }
    
    func decodeData<T: Decodable>(type: T.Type, data: Data) -> T? {
        
        do {
            let decoder = JSONDecoder()
            let parsingData = try decoder.decode(type, from: data)

            let items = parsingData

            return items
        } catch {
            return nil
        }
        
    }
    
}
