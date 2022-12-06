//
//  UIImage+Extension.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/12/03.
//

import UIKit

extension UIImage {
    // resizing using CompressingQuility
    func compressTo(expectedSizeInKb: Int) -> Data? {
        let sizeInBytes = expectedSizeInKb * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0

        while (needCompress && compressingValue > 0.0) {
            if let data:Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        if let data = imgData {
            if (data.count < sizeInBytes) {
                return data
            }
        }
        return nil
    }

    // resizing using size
    func resize(expectedSizeInKb: Int) -> Data? {
        let nowWidth: CGFloat = self.size.width
        var ratio: CGFloat = 1
        let sizeInBytes = expectedSizeInKb * 1024
        guard var data: Data = self.jpegData(compressionQuality: 1.0) else { return nil }

        while data.count > sizeInBytes {
            ratio += 3
            let changeWidth = nowWidth / ratio

            let size = CGSize(width: changeWidth, height: changeWidth)
            let render = UIGraphicsImageRenderer(size: size)
            let renderImage = render.image { context in
                self.draw(in: CGRect(origin: .zero, size: size))
            }
            data = renderImage.jpegData(compressionQuality: 1.0)!
        }

        return data
    }
}
