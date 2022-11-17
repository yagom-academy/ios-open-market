//  Created by Aejong, Tottale on 2022/11/17.

import Foundation

final class NetworkAPIProvider {
    
    let session: URLSessionProtocol
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchProductList(query: [Query: String]?, completion: @escaping (ProductList) -> Void) {
        fetch(path: .productList(query: query)) { data in
            guard let productList: ProductList = DecodeManger.shared.fetchData(data: data) else {
                return
            }
            completion(productList)
        }
    }
}

extension NetworkAPIProvider {
    
    func fetch(path: NetworkAPI, completion: @escaping (Data) -> Void) {
        guard let url = path.urlComponents.url else { return }

        session.dataTask(with: url) { data, response, error in
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
