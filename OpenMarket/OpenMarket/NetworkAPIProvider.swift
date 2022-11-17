//  Created by Aejong, Tottale on 2022/11/17.

import Foundation

class NetworkAPIProvider {
    
    let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch(path: NetworkAPI, completion: @escaping (Data) -> Void) {
        
        guard let url = path.urlComponents.url else { return }
        
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

