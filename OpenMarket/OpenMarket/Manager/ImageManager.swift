//
//  ImageManager.swift
//  OpenMarket
//
//  Created by JINHONG AN on 2021/08/24.
//

import Foundation
import UIKit.UIImage

struct ImageManager {
    private let imageRequestable: ImageRequestable
    
    init(imageRequestable: ImageRequestable = ImageModule()) {
        self.imageRequestable = imageRequestable
    }
    
    func fetchImage(from urlPath: String, completionHandler: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: urlPath) else {
            completionHandler(.failure(NetworkError.invalidURL))
            return nil
        }
        return imageRequestable.loadImage(with: url, completionHandler: completionHandler)
    }
}
