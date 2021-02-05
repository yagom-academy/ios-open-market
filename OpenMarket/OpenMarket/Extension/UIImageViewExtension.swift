//
//  UIImageViewExtension.swift
//  OpenMarket
//
//  Created by Yeon on 2021/02/05.
//

import UIKit

extension UIImageView {
    func setImageFromServer(with imageURL: String) {
        ItemManager.shared.loadItemImage(with: imageURL) { result in
            switch result {
            case .success(let data):
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    self.image = image
                }
            case .failure(let error):
                print(error)
                //NotificationCenter.default.post(name: Notification.Name.failGetImage, object: error)
            }
        }
    }
}
