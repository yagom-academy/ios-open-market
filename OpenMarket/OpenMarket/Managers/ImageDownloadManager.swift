//
//  ImageDownloadManager.swift
//  OpenMarket
//
//  Created by Jost, 잼킹 on 2021/08/23.
//

import UIKit

class ImageDownloadManager {

    static func downloadImage(with url: String, completion: @escaping (UIImage) -> Void = { _ in }) -> URLSessionDataTask? {
        guard let imageUrl = URL(string: url) else {
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: imageUrl) { (data, resopnce, error) in
            guard error == nil else {
                return
            }
            
            if let imageData = data,
               let image = UIImage(data: imageData) {
                ImageCacheManager.shared.setData(of: image, for: url)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
        task.resume()
        return task
    }
}
