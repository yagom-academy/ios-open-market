//
//  NetworkManager.siswift
//  OpenMarket
//
//  Created by Tak on 2021/06/02.
//

import Foundation

class NetworkManager {
    var convertedData: MarketItems?
    func startLoad(completionHandler: @escaping (Result<MarketItems,APIError>) -> Void) {
        let url = URL(string: "https://camp-open-market-2.herokuapp.com/items/1")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completionHandler(.failure(APIError.failedNetwork))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(APIError.responseProblem))
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                if let convertedData = try? decoder.decode(MarketItems.self, from: data) {
                    self.convertedData = convertedData
                    print(convertedData)
                }
            }
        }
        task.resume()
    }
}
