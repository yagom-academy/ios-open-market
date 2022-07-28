enum Currency: Int, Decodable {
    case krw
    case usd
    
    static var toString: [String] {
        Titles.allCases.map { String(describing: $0).uppercased() }
    }
}
