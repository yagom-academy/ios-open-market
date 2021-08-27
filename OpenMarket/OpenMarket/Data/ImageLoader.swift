//
//  ImageLoder.swift
//  OpenMarket
//
//  Created by KimJaeYoun on 2021/08/27.
//

import UIKit

class ImageLoader {
   private var runningRequests = [UUID : URLSessionDataTask]()
    
    func downloadImage(reqeustURL: String?, imageCachingKey: Int, _ completionHandler: @escaping (UIImage) -> ()) -> UUID? {
        
        if let image = ImageCacher.shared.pullImage(forkey: imageCachingKey) {
            completionHandler(image)
            return nil
        }
        
        guard let urlString = reqeustURL, let url = URL(string: urlString) else {
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            guard let downloadImage = UIImage(data: data) else { return }
            
            ImageCacher.shared.save(downloadImage, forkey: imageCachingKey)
            completionHandler(downloadImage)
        }
        let taskIdentifier = UUID()
        runningRequests[taskIdentifier] = task
        task.resume()
        return taskIdentifier
    }
    
    func cancelRequest(_ taskIdentifier: UUID) {
        runningRequests[taskIdentifier]?.cancel()
        runningRequests.removeValue(forKey: taskIdentifier)
    }
    
}
