enum Currency: Int, Decodable, CaseIterable {
    case krw
    case usd
    
    static var toString: [String] {
        Currency.allCases.map { String(describing: $0).uppercased() }
    }
    
    static func toIndex(using string: String) -> Int? {
        switch string.uppercased() {
        case "KRW":
            return 0
        case "USD":
            return 1
        default:
            return nil
        }
    }
}
