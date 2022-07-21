//
//  UIImageView+Extensions.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/21.
//

import UIKit

extension UIImageView {
    func loadImage(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            self.image = UIImage(data: data)
        } catch {
            fatalError("error")
        }
    }
}
