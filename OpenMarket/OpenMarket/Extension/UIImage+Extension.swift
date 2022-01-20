import UIKit
extension UIImage {
    func squareImage(length: CGFloat) -> UIImage? {
        let originWidth: CGFloat = self.size.width
        let originHeight: CGFloat = self.size.height
        var resizeWidth: CGFloat = length
        var resizeHeight: CGFloat = length
        
        UIGraphicsBeginImageContext(CGSize(width: length, height: length))
        
        let sizeRatio = length / max(originWidth, originHeight)
        if originWidth > originHeight {
            resizeWidth = length
            resizeHeight = originHeight * sizeRatio
        } else {
            resizeWidth = originWidth * sizeRatio
            resizeHeight = length
        }
        
        self.draw(in: CGRect(x: length / 2 - resizeWidth / 2,
                             y: length / 2 - resizeHeight / 2,
                             width: resizeWidth, height: resizeHeight))
        
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizeImage
    }
}
