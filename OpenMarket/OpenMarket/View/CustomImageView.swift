//
//  CustomImageView.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/09/15.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    var task: URLSessionDataTask!
    
    func loadImage(from url: URL) {
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        if let task = task {
            task.cancel()
        }
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let newImage = UIImage(data: data) else {
                return print(NetworkError.invalidURL)
            }
            
            imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task.resume()
    }
}
