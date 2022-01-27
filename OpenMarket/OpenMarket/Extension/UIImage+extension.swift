import UIKit

extension UIImage {
    func resize(multiplier: CGFloat) -> UIImage {
        let newWidth = self.size.width * multiplier
        let newheight = self.size.height * multiplier
        let size = CGSize(width: newWidth, height: newheight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }
    
    func cropSquare() -> UIImage? {
        let imageSize = self.size
        let shortLength = imageSize.width < imageSize.height ? imageSize.width : imageSize.height
        let origin = CGPoint(
            x: imageSize.width / 2 - shortLength / 2,
            y: imageSize.height / 2 - shortLength / 2
        )
        let size = CGSize(width: shortLength, height: shortLength)
        let square = CGRect(origin: origin, size: size)
        guard let squareImage = self.cgImage?.cropping(to: square) else {
            return nil
        }
        return UIImage(cgImage: squareImage, scale: 1.0, orientation: self.imageOrientation)
    }
}
