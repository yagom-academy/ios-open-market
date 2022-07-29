enum Currency: Int, Decodable, CaseIterable {
    case krw
    case usd
    
    static var toString: [String] {
        Currency.allCases.map { String(describing: $0).uppercased() }
    }
}
