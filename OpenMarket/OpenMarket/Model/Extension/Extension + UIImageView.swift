//
//  Extension + UIImageView.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/23.
//

import UIKit

extension UIImageView {
    func getImge(urlString: String) {
        if let image = ImageCacheManager.shared.object(forKey: urlString as NSString) {
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let dataTask = URLSession(configuration: .default).dataTask(with: url) { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode)  else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.image = image
                ImageCacheManager.shared.setObject(image, forKey: urlString as NSString)
            }
        }
        dataTask.resume()
    }
}
