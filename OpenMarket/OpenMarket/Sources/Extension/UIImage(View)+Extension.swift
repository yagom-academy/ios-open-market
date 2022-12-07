//
//  OpenMarket - UIImage(View)+Extension.swift
//  Created by Zhilly, Dragon. 22/11/23
//  Copyright © yagom. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(url: URL?) {
        DispatchQueue.global().async { [weak self] in
            if let targetURL = url,
               let data = try? Data(contentsOf: targetURL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
       
        return renderImage
    }
}
