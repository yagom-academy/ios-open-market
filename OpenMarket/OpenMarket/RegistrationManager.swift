//
//  RegistrationManager.swift
//  OpenMarket
//
//  Created by yeha on 2022/01/25.
//

import Foundation
import UIKit

class RegistrationManager {

    let item = RegisterProductRequest(name: <#String#>, descriptions: <#String#>, price: <#Int#>, currency: <#Currency#>, secret: <#String#>)

    var name: String {
        didSet {
            item.name = name
        }

    var images: [Data] = []

    init(item: RegisterProductRequest) {
        <#statements#>
    }

    func getItem() {
        let item = RegisterProductRequest(

    }

    func convertImage(_ image: UIImage) {
        let convertedImage = image.pngData()!
        images.append(convertedImage)
    }

    func registerItem() {
        ProductService().registerProduct(
            parameters: item,
            session: HTTPUtility.defaultSession,
            images: images
        ) { result in
            switch result {
            case .success(let product):
                print("\(product) 등록 성공")
            case .failure:
                print("상품 등록 실패")
            }
        }
    }
}
