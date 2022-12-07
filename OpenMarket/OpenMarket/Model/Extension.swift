//
//  Extension.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/12/07.
//

import UIKit

extension NSMutableData {
    func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

extension UIImage {
    func compressTo(expectedSizeInKb:Int) -> Data? {
        let sizeInBytes = expectedSizeInKb * 1024
        var needCompress: Bool = true
        var imageData: Data?
        var compressingValue: CGFloat = 1.0
        
        while (needCompress && compressingValue > 0.0) {
            if let data: Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imageData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        if let data = imageData {
            if (data.count < sizeInBytes) {
                return data
            }
        }
        return nil
    }
}
