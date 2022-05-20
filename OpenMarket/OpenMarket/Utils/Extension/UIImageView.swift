//
//  UIImageView.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/20.
//

import UIKit

extension UIImageView {
    func fetchImage(url: URL, completion: @escaping (UIImage) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, _ in
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard let image = UIImage(data: data) else {
                return
            }
            
            completion(image)
            
        }
        .resume()
    }
}
