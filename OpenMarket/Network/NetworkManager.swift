//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/24.
//

import Foundation

class NetworkManager {
    
    static var shared = NetworkManager()
    var isPaginating = false
    let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func getItemsOfPageData(pagination: Bool, pageNumber: Int, completion: @escaping (Data?, Int?)->(Void))  {
        if pagination {
            isPaginating = true
        }
        guard let url = URL(string: Network.baseURL + "/items/\(pageNumber)") else { return  }
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            self?.checkValidation(data: data, response: response, error: error)
            if pagination {
                self?.isPaginating = false
            }
            completion(data, pageNumber)
        }.resume()
    }
    
    private func checkValidation(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            fatalError("\(error)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid Response")
            return
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("Status Code: \(httpResponse.statusCode)")
            return
        }
        
        guard let _ = data else {
            print("Invalid Data")
            return
        }
    }
    
    func postItem(requestData: Request, completion: @escaping (Data?)->(Void)){
        
        guard let url = URL(string: Network.baseURL + "/item") else { return }
        
        var request = URLRequest(url: url)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.POST.rawValue
        request.httpBody = encodedData(data: requestData)
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            self?.checkValidation(data: data, response: response, error: error)
            
            completion(data)
        }.resume()
        
    }
    
    func encodedData(data: Request) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(data)
    }
}


