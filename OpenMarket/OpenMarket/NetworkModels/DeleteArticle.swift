//
//  DeleteArticle.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/14.
//

import Foundation

class DeleteArticle {
    
    private let urlProcess: URLProcessUsable
    
    init(urlProcess: URLProcessUsable) {
        self.urlProcess = urlProcess
    }
    
    func encodePassword(urlRequest: URLRequest?, password: String) -> Data? {
        let ones = PasswordArticle(password: password)
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(ones)
            
            return data
        } catch {
            return nil
        }
    }
    
    func deleteData(urlRequest: URLRequest?, data: Data?, completion: @escaping (Bool) -> Void) {
        guard let request = urlRequest else { return }
        
        URLSession.shared.uploadTask(with: request, from: data) { (data, response, error) in
            if error != nil { return }
            if self.urlProcess.checkResponseCode(response: response) {
                print("DELETE성공")
                completion(true)
            }
            else {
                print("DELETE에러")
                completion(false)
            }
        }.resume()
    }
    
}
