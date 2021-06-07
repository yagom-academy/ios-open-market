//
//  URLSessionManager.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/05/28.
//

import Foundation
class NetworkManager<T: Decodable>: Networkable {
    let clientRequest: GETRequest

    init(clientRequest: GETRequest){
        self.clientRequest = clientRequest
    }
    
    func getServerData<T: Decodable>(url: URL, completionHandler: @escaping (T) -> Void) {
        URLSession.shared.dataTask(with: url){ data, response, error in
            if error != nil { return }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else { return }

            if let mimeType = httpResponse.mimeType,
               mimeType == "application/json",
               let data = data {
                guard let convertedData = try? JSONDecoder().decode(T.self, from: data) else { return }
                completionHandler(convertedData)
            }
        }.resume()
    }
}
