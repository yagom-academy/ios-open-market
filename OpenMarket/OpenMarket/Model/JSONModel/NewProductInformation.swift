import Foundation

struct NewProductInformation: Codable {
    let name: String
    let descriptions: String
    let price: Double
    let discountedPrice: Double
    let currency: Currency
    let stock: Int
    let secret: String
    
    init(name: String, descriptions: String, price: Double, discountedPrice: Double = 0, currency: Currency, stock: Int = 0, secret: String = "q?QZnt6zztVyw-NA") {
         self.name = name
         self.descriptions = descriptions
         self.price = price
         self.discountedPrice = discountedPrice
         self.currency = currency
         self.stock = stock
         self.secret = secret
     }
}
