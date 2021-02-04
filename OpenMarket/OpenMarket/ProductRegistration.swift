
import Foundation

struct ProductRegistration {
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let images: [Data]
    let password: String
    
    var description: [String: Any?] {[
        "title": title,
        "descriptions": descriptions,
        "price": price,
        "currency": currency,
        "stock": stock,
        "discounted_price": discountedPrice,
        "images": images,
        "password": password
    ]}
}
