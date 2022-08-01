enum Corrency: Int, Decodable, CaseIterable {
    case krw
    case usd
    
    static var toString: [String] {
        Corrency.allCases.map { String(describing: $0).uppercased() }
    }
}
