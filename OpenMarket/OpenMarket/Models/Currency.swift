enum Currency: String, Codable {
    case krw = "KRW"
    case usd = "USD"
    
    var unit: String {
        return self.rawValue
    }
}

extension Currency: Hashable { }
