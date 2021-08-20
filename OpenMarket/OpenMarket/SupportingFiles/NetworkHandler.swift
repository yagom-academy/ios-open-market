//
//  NetworkHandler.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/17.
//

import Foundation

struct NetworkHandler {
    func request(api: OpenMarketAPI, form: DataForm? = nil) {
        guard let url = URL(string: api.request.url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = api.request.method.description
        request.httpBody = try? form?.createBody()
        request.setValue(form?.contentType, forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
