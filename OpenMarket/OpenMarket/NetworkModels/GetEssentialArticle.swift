//
//  GetEssentilaArticle.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/14.
//

import Foundation

class GetEssentialArticle {
    
    let urlProcess = URLProcess()
    
    func getParsing() {
        guard let relativeURL = urlProcess.setURLPath(methodType: "POST") else { return }

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let dataTask = session.dataTask(with: relativeURL) { (data, response, error) in
            guard error == nil else { return }

            if self.urlProcess.checkResponseCode(response: response) {
                guard let resultData = data else { return }
                self.decodeData(data: resultData)
            } else { return }
        }
        dataTask.resume()
    }
    

    
    func decodeData(data: Data) {
        
        do {
            let decoder = JSONDecoder()
            let parsingData = try decoder.decode(EntireArticle.self, from: data)

            let items = parsingData.items

            print("\(items.first?.title)")
        } catch {
            print("에러")
        }
        
    }
    
}
