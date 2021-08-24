//
//  ImageModule.swift
//  OpenMarket
//
//  Created by JINHONG AN on 2021/08/24.
//

import Foundation
import UIKit.UIImage

struct ImageModule: ImageRequestable {
    private let rangeOfSuccessState = 200...299
    private let customURLSession: URLSession = {
        let oneKilobyte = 1024
        let oneMegabyte = oneKilobyte * oneKilobyte
        URLCache.shared.memoryCapacity = 512 * oneMegabyte
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        
        return URLSession(configuration: config)
    }()
    
    func loadImage(with url: URL, completionHandler: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDataTask {
        let dataTask = customURLSession.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse,
               rangeOfSuccessState.contains(response.statusCode),
               let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completionHandler(.success(image))
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkError.unknown))
                }
            }
        }
        dataTask.resume()
        return dataTask
    }
}
