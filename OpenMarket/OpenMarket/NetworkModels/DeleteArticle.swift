//
//  DeleteArticle.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/14.
//

import Foundation

class DeleteArticle {
    let urlProcess = URLProcess()
    
    func encodePassword(password: String) {
        let ones = PasswordArticle(password: password)
        
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(ones)
        
            guard var request = urlProcess.setURLRequest(requestMethodType: "DELETE") else { return }
            request.httpBody = data
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    print("에러")
                    return
                }
                if self.urlProcess.checkResponseCode(response: response) {
                    print("DELETE성공")
                }
                else {
                    print("DELETE에러")
                }
                
            }.resume()
            
        } catch {
            print(error)
        }
    }
}
