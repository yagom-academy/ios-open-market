//
//  String.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/18.
//

import UIKit

extension String {
    
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, attributeString.length)
        )
        return attributeString
    }
    
    func convertImageView() -> UIImageView? {
 
        guard let url = URL(string: self) else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        guard let image = UIImage(data: data) else {
            return nil
        }
        
        let imageView = UIImageView(image: image)
        
        return imageView
    }
}
