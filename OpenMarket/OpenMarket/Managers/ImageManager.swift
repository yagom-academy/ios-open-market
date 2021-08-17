//
//  ImageManager.swift
//  OpenMarket
//
//  Created by Jost, 잼킹 on 2021/08/17.
//

import Foundation

class ImageManager {
    var imageDataMap: [String: Data] = [:]
    static let shaerd: ImageManager = ImageManager.init()
    
    private init() {}
    
    func cacheImageData(imageUrl: String) {
        guard let url = URL(string: imageUrl),
              let data = try? Data(contentsOf: url) else {
            return
        }
        imageDataMap[imageUrl] = data
    }
    
    func cacheImagData(imageUrl: String, data: Data) {
        imageDataMap[imageUrl] = data
    }
    
    func loadImageData(imageUrl: String) -> Data? {
        return imageDataMap[imageUrl]
    }
}
