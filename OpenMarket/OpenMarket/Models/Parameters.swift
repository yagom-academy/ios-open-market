import UIKit.NSDataAsset

struct Parameters {
    static let key: String = "params"
    var parameterDictionary: [String: Any] = [:]
    
    init(name: String, descriptions: String, price: Double, currency: Currency, secret: String, discountedPrice: Double? = 0, stock: Int? = 0) {
        self.parameterDictionary["name"] = name
        self.parameterDictionary["descriptions"] = descriptions
        self.parameterDictionary["price"] = price
        self.parameterDictionary["currency"] = Currency.toString[currency.rawValue]
        self.parameterDictionary["discounted_price"] = discountedPrice
        self.parameterDictionary["stock"] = stock
        self.parameterDictionary["secret"] = secret
    }
    
    init(secret: String) {
        self.parameterDictionary["secret"] = secret
    }
    
    func returnParamatersToJsonData() -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameterDictionary, options: [])
            return jsonData
        } catch {
            print(error)
            return nil
        }
    }
}
