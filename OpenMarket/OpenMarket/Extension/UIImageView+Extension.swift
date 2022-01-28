//
//  UIImageView+Extension.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/26.
//

import UIKit

extension UIImageView {
  func setImage(url: String) {
    let api = APIManager(urlSession: URLSession(configuration: .default), jsonParser: JSONParser())
    
    let cacheKey = NSString(string: url)
    if let cacheImage = ImageCacheManager.shared.object(forKey: cacheKey) {
      self.image = cacheImage
      return
    }
    
    api.requestProductImage(url: url) { [weak self] response in
      switch response {
      case .success(let data):
        guard let image = UIImage(data: data) else {
          return
        }
        ImageCacheManager.shared.setObject(image, forKey: cacheKey)
        DispatchQueue.main.async {
          self?.image = image
        }
      case .failure(let error):
        print(error)
      }
    }
  }
}
