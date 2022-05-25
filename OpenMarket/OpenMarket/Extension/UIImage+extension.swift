//
//  UIImage+extension.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/26.
//

import UIKit

extension UIImage {
    static var plus: UIImage {
        return UIImage(named: "plus") ?? UIImage()
    }
    
    static var photo: UIImage? {
        return UIImage(systemName: "photo.on.rectangle.angled")
    }
    
    static var downKeyboard: UIImage? {
        return UIImage(systemName: "keyboard.chevron.compact.down")
    }
}
