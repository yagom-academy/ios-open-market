//  Created by Aejong, Tottale on 2022/12/02.

import Foundation

struct NewProductInfo: Codable {
    let name, newProductDescription: String
    let price: Int
    let currency: String
    let discountedPrice, stock: Int?
    let secret: String = "t2j8r3x9zseesw6y"

    enum CodingKeys: String, CodingKey {
        case name
        case newProductDescription = "description"
        case price, currency
        case discountedPrice = "discounted_price"
        case stock, secret
    }
}
