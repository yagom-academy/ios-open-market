//
//  PostDataManager.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/27.
//

import Foundation
import UIKit

struct PostDataManager {
    let segmentedControllerIndex: Int
    let postPramData: [String:String]
    var tempPostImage: [UIImage]
    var postParam: ProductParam?
    var images: [Data] = []
    var imagesIsEmpty: Bool = false
    
    
    func requestData() {
        let urlSessionProvider = URLSessionProvider()
        guard let postParam = postParam else {
            return
        }
        urlSessionProvider.postData(parameters: postParam, registImages: images) { ( result: Result<Data, NetworkError>) in
            switch result {
            case .success(_): break
            case .failure(_):
                print(NetworkError.statusCodeError)
            }
        }
    }
    
    mutating func saveData() {
        guard let name = postPramData["name"],
              let price = postPramData["price"],
              let discountedPrice = postPramData["discountedPrice"],
              let stock = postPramData["stock"],
              let description = postPramData["description"] else {
                  return
              }
        let currency: Currency
        if segmentedControllerIndex == 0 {
            currency = .KRW
        } else {
            currency = .USD
        }
        
        self.postParam = ProductParam(name: name,
                                      descriptions: description,
                                      price: Double(price) ?? 0,
                                      currency: currency,
                                      discountedPrice: Double(discountedPrice),
                                      stock: Int(stock),
                                      secret: "K!Nx@Jdb9HZBg?WA")
        return
    }
    
    mutating func saveImages() {
        tempPostImage.forEach {
            guard let image = $0.jpegData(compressionQuality: 0.001) else {
                return
            }
            images.append(image)
        }
        imagesIsEmpty = images.isEmpty
    }
}
