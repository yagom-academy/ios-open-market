//
//  HTTPManager.swift
//  OpenMarket
//
//  Created by 허윤영 on 10/05/2022.
//

import Foundation

struct HTTPManager {
    var hostURL: String
    
    init(hostURL: String = "https://market-training.yagom-academy.kr/") {
        self.hostURL = hostURL
    }
    
    func loadProductData(of productID: String, completionHandler: @escaping (Data) -> Void) {
        let requestURL = hostURL + "/api/products/" + productID
        guard let url = URL(string: requestURL) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200 ... 299).contains(httpResponse.statusCode) else {
                return
            }
            if let mimeType = httpResponse.mimeType,
               mimeType == "application/json",
               let data = data {
                completionHandler(data)
                return
            }
        }
        task.resume()
    }
}
