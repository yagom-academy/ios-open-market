//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/16.
//

import UIKit

struct NetworkManager {
    public static let publicNetworkManager = NetworkManager()
    
    func getJSONData<T: Codable>(url: String, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        HTTPManager.shared.requestGet(url: url) { data in
            guard let data: T = JSONConverter.shared.decodeData(data: data) else {
                completion(.failure(.missingData))
                return
            }
            
            completion(.success(data))
        }
    }
    
    func getImageData(url: String, completion: @escaping (UIImage) -> ()) {
        let cachedKey = NSString(string: "\(url)")
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) {
            return completion(cachedImage)
        } 
        
        HTTPManager.shared.requestGet(url: url) { data in
            guard let image = UIImage(data: data) else {
                return
            }
            
            ImageCacheManager.shared.setObject(image, forKey: cachedKey)
            completion(image)
        }
    }
}
