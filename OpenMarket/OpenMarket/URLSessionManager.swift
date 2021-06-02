//
//  URLSessionManager.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/05/28.
//

import Foundation
class URLSessionManager<T: Decodable> {
    let clientRequest: ClientRequest
    
    init(clientRequest: ClientRequest){
        self.clientRequest = clientRequest
    }
    
    func getServerData<T: Decodable>(completionHandler: @escaping (T) -> Void) {
        URLSession.shared.dataTask(with: clientRequest.urlRequest.url!){ data, response, error in
            if error != nil {
                print("1")
                return }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            print(httpResponse.statusCode)
            guard (200...299).contains(httpResponse.statusCode) else {
                print("2")
                return
            }
            
            if let mimeType = httpResponse.mimeType,
               mimeType == "application/json",
               let data = data {
                let decoder = JSONDecoder()
                guard let convertedData = try? decoder.decode(T.self, from: data) else {
                    print("3")
                    return
                }
                completionHandler(convertedData)
            }
        }.resume()
    }
}
