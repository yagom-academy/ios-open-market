//
//  UIImageExtension.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/02.
//

import UIKit

extension UIImageView {
    func setImageWithURL(urlString: String) {
        ImageLoader.shared.load(urlString: urlString) { result in
            switch result {
            case .failure(let error):
                debugPrint("❌:\(error.localizedDescription)")
            case .success(let image):
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
