//
//  UIImageExtension.swift
//  OpenMarket
//
//  Created by 천수현 on 2021/05/13.
//

import UIKit

extension UIImage {
    static func fetchImageFromURL(string: String?) -> UIImage? {
        guard let urlString = string,
              let url = URL(string: urlString),
              let data = try? Data(contentsOf: url) else {
            return nil
        }

        return UIImage(data: data)
    }
}
