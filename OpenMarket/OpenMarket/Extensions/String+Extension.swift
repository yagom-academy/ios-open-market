//
//  String+Extension.swift
//  OpenMarket
//
//  Created by Aejong, Tottale on 2022/11/22.
//


import UIKit

extension String {
    func foregroundColor(_ color: UIColor) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.foregroundColor : color])
    }
    
    var attributed: NSAttributedString {
        NSAttributedString(string: self)
    }
}
