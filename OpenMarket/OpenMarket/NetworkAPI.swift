//  Created by Aejong, Tottale on 2022/11/15.

import Foundation

class NetworkAPI {
    static let shared = NetworkAPI()
    private init() {}
    
    let scheme = RequestConstant.scheme
    let host = RequestConstant.host
    
    var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        
        return urlComponents
    }
    
    func fetch(path: String, parameters: [String: String]?, completion: @escaping (Data) -> Void) {
        var urlComponents = self.urlComponents
        urlComponents.path = path
        if let parameters = parameters {
            urlComponents.setQueryItems(with: parameters)
        }
        
        guard let url = urlComponents.url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                dump(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self.handleServerError(response)
                return
            }
            
            guard let data = data else { return }
            
            completion(data)
        }.resume()
        
    }
    
    private func handleServerError(_ response: URLResponse?) {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        print(httpResponse.statusCode)
    }

}
