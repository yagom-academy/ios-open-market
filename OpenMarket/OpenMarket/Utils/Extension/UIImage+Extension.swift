import UIKit

extension UIImage {

    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }

    func crop() -> UIImage {
        let cgImage = self.cgImage!
        let width = cgImage.width
        let height = cgImage.height
        let shortestLength = min(width, height)
        let xOffset = (width - shortestLength) / 2
        let yOffset = (height - shortestLength) / 2
        let square = CGRect (
            x: xOffset,
            y: yOffset,
            width: shortestLength,
            height: shortestLength
            ).integral
        guard let croppedImage = cgImage.cropping(to: square) else {
            return UIImage()
        }
        return UIImage(cgImage: croppedImage)
    }
}
