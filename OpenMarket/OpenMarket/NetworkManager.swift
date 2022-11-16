//
//  NetworkManager.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

class NetworkManager {
    let baseURL: String = "https://openmarket.yagom-academy.kr"
    
    func requestHealthChecker() {
        // URL 생성
        guard let url = URL(string: baseURL + "/healthChecker") else {
            return
        }
        
        // urlsession 생성
        let session = URLSession(configuration: .default)
        
        // urlrequest 생성
        let urlRequest = URLRequest(url: url)
        
        // urlsession task를 만들어 준다.
        let task = session.dataTask(with: urlRequest) { data, response, error in
            // 1. request 에러 체크
            guard error == nil else {
                return
            }
            
            // 2. response 에러 체크
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                return
            }
            
            // 3. decode Data
            guard let data = data,
                  let decodeData = String(data: data, encoding: .utf8) else { // 1011011100
                return
            }
            print(decodeData)
        }
        
        // task를 실행해준다.
        task.resume()
    }
}
