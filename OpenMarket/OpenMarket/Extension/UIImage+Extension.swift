//
//  UIImage+Extension.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/20.
//

import UIKit

extension UIImage {
  func resize(maxBytes: Int) -> UIImage {
    var renderImage = self
    var newWidth = self.size.width / 2
    while let imageSize = renderImage.jpegData(compressionQuality: 1), imageSize.count > maxBytes {
      let scale = newWidth / self.size.width
      let newHeight = self.size.height * scale
      let size = CGSize(width: newWidth, height: newHeight)
      let render = UIGraphicsImageRenderer(size: size)
      renderImage = render.image {
        context in self.draw(in: CGRect(origin: .zero, size: size))
      }
      newWidth /= 2
      print(renderImage.jpegData(compressionQuality: 1)!)
    }
    return renderImage
  }
}
