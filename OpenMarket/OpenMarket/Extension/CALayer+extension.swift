//
//  CALayer+extension.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/09.
//

import UIKit

extension CALayer {
    func addBorder(
        edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
        case .top:
            border.frame =
                CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame =
                CGRect(x: 0, y: frame.height - thickness, width: frame.width * 3, height: thickness)
        case .left:
            border.frame =
                CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame =
                CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        border.backgroundColor = color.cgColor
        addSublayer(border)
    }
}

extension UIApplication {
    
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
