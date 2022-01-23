import UIKit

extension UIImage {
    
    func croppedToSquareForm() -> UIImage? {
        let shorterLength = min(self.size.width, self.size.height)
        
        let xOffset = Double(self.size.width - shorterLength) / Double(2)
        let yOffset = Double(self.size.height - shorterLength) / Double(2)
        let targetRect = CGRect(x: xOffset, y: yOffset, width: shorterLength, height: shorterLength)
        
        guard let croppedCGImage = self.cgImage?.cropping(to: targetRect) else {
            return nil
        }
        
        return UIImage(cgImage: croppedCGImage)
    }

    //if self.size is smaller than maxWidth/maxHeight, it isn't resized
    func resized(width: CGFloat, height: CGFloat) -> UIImage {
        let targetSize = CGSize(width: width, height: height)
        let resizedImage = UIGraphicsImageRenderer(size: targetSize).image { context in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
        return resizedImage
    }
    
    func jpegData(underBytes maximumBytes: Int) -> Data? {
        //STEP 1 - Low Compression
        guard let lowCompressedData = self.jpegData(compressionQuality: 1) else {
            return nil
        }
        guard lowCompressedData.count > maximumBytes else {
            return lowCompressedData
        }
        
        //STEP 2 - Middle Compression
        guard let middleCompressedData = self.jpegData(compressionQuality: 0.5) else {
            return nil
        }
        guard middleCompressedData.count > maximumBytes else {
            return middleCompressedData
        }
        
        //STEP 3 - High Compression
        guard let highCompressedData = self.jpegData(compressionQuality: 0) else {
            return nil
        }
        guard highCompressedData.count > maximumBytes else {
            return highCompressedData
        }
        
        return nil
    }
}
