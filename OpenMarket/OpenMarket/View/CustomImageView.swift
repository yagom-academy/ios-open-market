//
//  CustomImageView.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/09/15.
//

import UIKit

class CustomImageView: UIImageView {
    var task: URLSessionDataTask!

    func loadImage(from url: URL) {
        image = nil

        if let task = task {
            task.cancel()
        }

        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let newImage = UIImage(data: data) else {
                return print(NetworkError.invalidURL)
            }

            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task.resume()
    }
}
