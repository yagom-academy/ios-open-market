//
//  Param.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/28.
//

import UIKit

enum VendorInfo {
    static let secret = "0hvvXjSeAS"
    static let identifier = "f27bc126-0335-11ed-9676-1776ba240ec2"
}

struct Param {
    let productName: String
    let price: String
    let discountedPrice: String
    let currency: String
    let stock: String
    let description: String
    let secret: String = VendorInfo.secret
}

struct ImageParam {
    let imageName: String
    let imageType: String
    let imageData: Data
}
