//
//  ProductProtocol.swift
//  OpenMarket
//
//  Created by Charlotte, Hosinging on 2021/08/10.
//

import Foundation

protocol ProductProtocol {
    var id: Int { get set }
    var title: String { get set }
    var price: Int { get set }
    var currency: String { get set }
    var stock: String { get set }
    var discountedPrice: Int { get set }
    var thumnails: [String] { get set }
    var registrationDate: Double { get set }
}

protocol ContainDescriptionProductProtocol : ProductProtocol {
    var description: String { get set }
    var images: [String] { get set }
}
