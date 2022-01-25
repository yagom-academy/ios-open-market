import UIKit

extension CALayer {
    func makeBorder(_ edges: [UIRectEdge], color: UIColor, width: CGFloat) -> CALayer {
        let border = CALayer()
        for edge in edges {
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect(x: 0, y: 0, width: frame.width, height: width)
            case UIRectEdge.bottom:
                border.frame = CGRect(x: 0, y: frame.height - width, width: frame.width, height: width)
            case UIRectEdge.left:
                border.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
            case UIRectEdge.right:
                border.frame = CGRect(x: frame.width - width, y: 0, width: width, height: frame.height)
            default:
                break
            }
        }
        border.backgroundColor = color.cgColor
        
        return border
    }
}
