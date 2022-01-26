import Foundation

enum Currency: String, Codable {
    case krw = "KRW"
    case usd = "USD"
    
    init?(unit: String) {
        self.init(rawValue: unit)
    }
    
    var unit: String {
        return self.rawValue
    }
}
