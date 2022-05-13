//
//  ProductRegistretion.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/10.
//

import Foundation

struct ProductRegistration: Codable {
    let identifier: String
    let parameters: RegistrationParameter
    let images: [Image]
    
    private enum CodingKeys: String, CodingKey {
        case identifier
        case parameters = "params"
        case images
    }
}
