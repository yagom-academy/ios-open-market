//
//  UIImageExtension.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/02.
//

import UIKit

extension UIImageView {
    func setWebImage(urlString: String) {
        ImageLoader.shared.load(urlString: urlString) { result in
            switch result {
            case .failure(let error):
                NotificationCenter.default.post(name: Notification.Name.failureImageLoad, object: error)
            case .success(let image):
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
