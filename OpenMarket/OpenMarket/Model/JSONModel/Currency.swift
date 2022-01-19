import Foundation

enum Currency: String, Codable {
    case KRW
    case USD
    
    init?(unit: String) {
        self.init(rawValue: unit)
    }
    
    var unit: String {
        return self.rawValue
    }
}
