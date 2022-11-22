//  NetworkManager.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/15.

import Foundation

final class NetworkManager {
    private let session: URLSessionable
    
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    // networkmanager: urlrequest 만들어서 session.datatask에 전달, 한번만 호출하고있냐?
    // 이거를 mockurlsession을 통해서 검증 -> 얘가 실제로 한번만 호출됐냐? 하고 urlrequest가 제대로 된 애가 들어왔냐? (endpoint 가지고 url 제대로 만들었냐?)
    func request<Model: Decodable>(endpoint: Endpointable,
                                   dataType: Model.Type,
                                   completion: @escaping (Result<Model, NetworkError>) -> Void) {
        guard let requestURL = endpoint.createURL() else {
            return completion(.failure(.URLError))
        }
        
        let request = URLRequest(url: requestURL)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completion(.failure(.URLError))
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                      return completion(.failure(.statusCodeError))
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            do {
                let result = try JSONDecoder().decode(dataType, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
    
    func checkAPIHealth(endpoint: Endpointable,
                        completion: @escaping (Result<HTTPURLResponse, NetworkError>) -> Void) {
        guard let requestURL = endpoint.createURL() else {
            return completion(.failure(.URLError))
        }
        
        let request = URLRequest(url: requestURL)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completion(.failure(.URLError))
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                      return completion(.failure(.statusCodeError))
            }
            
            completion(.success(response))
        }
        
        task.resume()
    }
}
