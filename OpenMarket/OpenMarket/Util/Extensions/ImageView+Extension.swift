//
//  ImageView+Extension.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

extension UIImageView {
  func loadImage(urlString: String) {
    let cacheKey = NSString(string: urlString)
    if let cacheImage = ImageCacheManager.shared.object(forKey: cacheKey) {
      self.image = cacheImage
      return
    }
    guard let url = URL(string: urlString) else { return }
    URLSession.shared.dataTask(with: url) { data, response, error in
      if let _ = error {
        DispatchQueue.main.async { [weak self] in
          self?.image = UIImage()
        }
        return
      }
      DispatchQueue.main.async { [weak self] in
        if let data = data, let image = UIImage(data: data) {
          ImageCacheManager.shared.setObject(image, forKey: cacheKey)
          self?.image = image
        }
      }
    }.resume()
  }
}
