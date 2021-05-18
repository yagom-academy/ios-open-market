//
//  DeleteArticle.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/14.
//

import Foundation

class DeleteArticle {
    
    let urlProcess = URLProcess()
    
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
    
    func deleteData(urlRequest: URLRequest?, data: Data?) {
        guard let request = urlRequest else { return }
        
        URLSession.shared.uploadTask(with: request, from: data) { (data, response, error) in

            if error != nil { return }
            if self.urlProcess.checkResponseCode(response: response) {
                print("DELETE성공")
            }
            else {
                print("DELETE에러")
            }
        }.resume()
    }
    
}
