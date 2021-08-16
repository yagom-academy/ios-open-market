//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by JINHONG AN on 2021/08/13.
//

import Foundation

struct NetworkManager {
    
    func lookUpList(on pageNum: Int, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let methodForm = OpenMarketAPIConstants.listGet
        guard let url = URL(string: methodForm.path + "\(pageNum)") else {
            return completionHandler(.failure(NetworkError.invalidURL))
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = methodForm.method
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let response = response as? HTTPURLResponse,
               OpenMarketAPIConstants.rangeOfSuccessState.contains(response.statusCode),
               let data = data {
                DispatchQueue.main.async {
                    completionHandler(.success(data))
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkError.unknown))
                }
            }
        }.resume()
    }
    
    func generateBoundary() -> String {
        return UUID().uuidString
    }
    
    func createDataBody(with parameters: [String: Any],and medias: [Media]?,separatedInto boundary: String) -> Data {
        let linebreak = "\r\n"
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary + linebreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(linebreak + linebreak)")
            body.append("\(value)\(linebreak)")
        }
        
        if let medias = medias {
            for media in medias {
                body.append("--\(boundary + linebreak)")
                body.append("Content-Disposition: form-data; name=\"\(media.key)\"; filename=\(media.fileName)\"\(linebreak)")
                body.append("Content-Type: \(media.mimeType + linebreak + linebreak)")
                body.append(media.data)
                body.append(linebreak)
            }
        }
        body.append("--\(boundary)--\(linebreak)")
        return body
    }
}
