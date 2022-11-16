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
    
    func requestProductListSearching() {
        //URL 생성
        guard let url = URL(string: baseURL + "/api/products?page_no=1&items_per_page=100" ) else {
            return
        }
        
        //URLSession 생성
        let urlSession = URLSession(configuration: .default)
        
        //URLRequest 생성
        let urlRequest = URLRequest(url: url)
        
        //URLSessionTask 생성
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            //1. request 에러 처리
            guard error == nil else {
                return
            }
            
            //2. respone 에러 처리
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                return
            }
            
            //3. data 받아오기
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let fetchData = try decoder.decode(ProductListResponse.self , from: data)
                print(fetchData)
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func requestDetailProductListSearching(_ id: Int) {
        //URL 생성
        guard let url = URL(string: baseURL + "/api/products" + "/\(id)") else {
            return
        }
        
        //URLSession 생성
        let urlSession = URLSession(configuration: .default)
        
        //URLRequest 생성
        let urlRequest = URLRequest(url: url)
        
        //URLSessionTask 생성
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            //1. request 에러 처리
            guard error == nil else {
                return
            }
            
            //2. respone 에러 처리
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                return
            }
            
            //3. data 받아오기
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let fetchData = try decoder.decode(Product.self , from: data)
                print(fetchData)
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
}
