//
//  URLSessionManager.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/05/28.
//

import Foundation

struct URLSessionManager<T: Decodable> {
    var result: T
    let clientRequest: ClientRequest
    let urlSessionForGet = URLSession()
    
    init(clientRequest: ClientRequest){
        self.clientRequest = clientRequest
    }
    
    mutating func getServerData(){
        urlSessionForGet.dataTask(with: clientRequest.urlRequest){ data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print(response)
                return
            }
            
            if let mimeType = httpResponse.mimeType,
               mimeType == "text/html",
               let data = data {
                let decoder = JSONDecoder()
                guard let convertedData = try? decoder.decode(T.self, from: data) else { return }
                result = convertedData
            }
        }
    }
}
