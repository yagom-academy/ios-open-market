//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/16.
//

import Foundation

struct NetworkManager {
    public static let publicNetworkManager = NetworkManager()
    
    func getJSONData<T: Codable>(url: String, type: T.Type, completion: @escaping (T) -> Void) {
        HTTPManager.shared.requestGet(url: url) { data in
            guard let data: T = JSONConverter.shared.decodeData(data: data) else {
                return
            }
            
            completion(data)
        }
    }
}
