//
//  ImageEncoder.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/06/01.
//

import UIKit

struct ImageEncoder {
    private enum Constant {
        static let defaultMaximumImageSize = 300 * 1024
        static let defualtResizeWidthValue: CGFloat = 100
        static let defaultCompressionQualityValue: CGFloat = 1
    }
    private let maximumImageSize: Int
    private let resizeWidthValue: CGFloat
    private let compressionQualityValue: CGFloat
    
    init(
        maximumImageSize: Int = Constant.defaultMaximumImageSize,
        resizeWidthValue: CGFloat = Constant.defualtResizeWidthValue,
        compressionQualityValue: CGFloat = Constant.defaultCompressionQualityValue
    ) {
        self.maximumImageSize = maximumImageSize
        self.resizeWidthValue = resizeWidthValue
        self.compressionQualityValue = compressionQualityValue
    }
    
    func encodeImage(image: UIImage) throws -> Data {
        
        guard let imageData = image.jpegData(compressionQuality: compressionQualityValue) else {
            throw UseCaseError.imageError
        }
        
        if imageData.count > maximumImageSize {
            let resizeValue = image.resize(newWidth: resizeWidthValue)
            guard let resizedImageData = resizeValue.jpegData(compressionQuality: compressionQualityValue),
                  resizedImageData.count < maximumImageSize else {
                throw(UseCaseError.imageError)
            }
            return resizedImageData
        }
        
        return imageData
    }
}
