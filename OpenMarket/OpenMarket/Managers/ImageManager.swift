//
//  ImageManager.swift
//  OpenMarket
//
//  Created by Jost, 잼킹 on 2021/08/17.
//

import Foundation

class ImageManager {
    private var imageDataMap: [String: Data] = [:]
    let noImageDataUrl = "https://folo.co.kr/img/gm_noimage.png"
    static let shared: ImageManager = ImageManager.init()
    
    private init() {
        guard let url = URL(string: noImageDataUrl),
              let data = try? Data(contentsOf: url) else {
            return
        }
        imageDataMap[noImageDataUrl] = data
    }
    
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
    
    func performBatchUpdate(urls: [String]) {
        for url in urls {
            DispatchQueue.global().async {
                ImageManager.shared.cacheImageData(imageUrl: url)
            }
        }
    }
}
