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
}
