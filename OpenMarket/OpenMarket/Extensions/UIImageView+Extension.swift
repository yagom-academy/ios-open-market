//
//  UIImageView+Extension.swift
//  OpenMarket
//
//  Created by Aejong, Tottale on 2022/11/22.
//

import UIKit

extension UIImageView {
    func setImageUrl(_ url: String) {
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: url) else { return }
            URLSession.shared.dataTask(with: url) { (data, result, error) in

                guard error == nil else {
                    DispatchQueue.main.async { [weak self] in
                        self?.image = UIImage()
                    }
                    return
                }

                DispatchQueue.main.async { [weak self] in
                    if let data = data, let image = UIImage(data: data) {
                        self?.image = image
                    }
                }
            }.resume()
        }
    }
}
