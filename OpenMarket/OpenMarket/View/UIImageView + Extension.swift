//
//  UIImageView + Extension.swift
//  OpenMarket
//
//  Created by Kiwi, Hugh on 2022/07/28.
//

import UIKit

extension UIImageView {
    func fetchImageData(url: String) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else { return }
            
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
