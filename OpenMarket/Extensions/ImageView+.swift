//
//  ImageView.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/17.
//

import UIKit

extension UIImageView {
    func requestImageDownload(url: String) {
        if let cacheImage = Cache.imageCache.object(forKey: url as NSString) {
            DispatchQueue.main.async() { [weak self] in
                self?.image = cacheImage
            }
        } else {
            guard let url = URL(string: url) else {
                return
            }
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    return
                }
                guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 else {
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                
                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                    Cache.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                }
            }.resume()
        }
    }
}
