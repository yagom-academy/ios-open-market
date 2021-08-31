//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/31.
//

import Foundation

typealias Parameters = [String: Any]

struct NetworkManager {
    private let session: URLSession
    let boundary = "Boundary-\(UUID().uuidString)"
    
    init(session: URLSession) {
        self.session = session
    }
    
    func commuteWithAPI(with API: RequestAPI) {
        guard let url = URL(string: API.url.description) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = API.method.description
        
        if API.contentType == .multipart {
            request.setValue(API.contentType.description + boundary, forHTTPHeaderField: "Content-Type")
        } else {
            request.setValue(API.contentType.description, forHTTPHeaderField: "Content-Type")
        }

        if let api = API as? RequestableWithBody {
            var body = Data()
            let lineBreakPoint = "\r\n"

            if let parameters = api.parameters {
                for (key, value) in parameters {
                    body.append("--\(boundary)\(lineBreakPoint)")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreakPoint + lineBreakPoint)")
                    body.append("\(value)\(lineBreakPoint)")
                }
            }
            
            if let medias = api.images {
                for media in medias {
                    body.append("--\(boundary)\(lineBreakPoint)")
                    body.append("Content-Disposition: form-data; name=\"\(media.fieldName)\"; filename=\"\(media.fileName)\"\(lineBreakPoint)")
                    body.append("Content-Type: \(media.mimeType)\(lineBreakPoint + lineBreakPoint)")
                    body.append(media.fileData)
                    body.append(lineBreakPoint)
                }
            }
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("error")
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("invalid response")
                return
            }
            if let data = data, let response = try? JSONDecoder().decode(Items.self, from: data) {
                return
            }
        }.resume()
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8){
            append(data)
        }
    }
}
