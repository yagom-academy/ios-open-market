//
//  OpenMarket - UIImageView+Extension.swift
//  Created by Zhilly, Dragon. 22/11/23
//  Copyright © yagom. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(url: URL?) {
        DispatchQueue.global().async { [weak self] in
            if let targetURL = url,
               let data = try? Data(contentsOf: targetURL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
