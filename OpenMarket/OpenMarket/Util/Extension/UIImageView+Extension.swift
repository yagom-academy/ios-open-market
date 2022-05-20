//
//  UIImageView+Extension.swift
//  OpenMarket
//
//  Created by Lingo, Quokka on 2022/05/20.
//

import UIKit

extension UIImageView {
  func setImage(with urlString: String) {
    if let image = ImageCache.shared.object(forKey: urlString as NSString) {
      self.image = image
      return
    }
    
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard error == nil else { return }
      
      if let data = data, let image = UIImage(data: data) {
        ImageCache.shared.setObject(image, forKey: urlString as NSString)
        DispatchQueue.main.async {
          self.image = UIImage(data: data)
        }
      }
    }.resume()
  }
}
