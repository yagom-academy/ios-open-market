//
//  ImageRequestable.swift
//  OpenMarket
//
//  Created by JINHONG AN on 2021/08/24.
//

import Foundation
import UIKit.UIImage

protocol ImageRequestable {
    func loadImage(with url: URL, completionHandler: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDataTask
}
