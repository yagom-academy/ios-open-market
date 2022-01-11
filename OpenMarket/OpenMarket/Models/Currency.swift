enum Currency: String, Codable {
    case krw = "KRW"
    case usd = "USD"
    
    var unit: String {
        switch self {
        case .krw:
            return "KRW"
        case .usd:
            return "USD"
        }
    }
}

extension Currency: Hashable { }
