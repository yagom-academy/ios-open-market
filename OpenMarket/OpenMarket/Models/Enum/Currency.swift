enum Currency: String, Decodable, CaseIterable {
    case krw = "KRW"
    case usd = "USD"
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .krw
        case 1:
            self = .usd
        default:
            return nil
        }
    }
    
    
    
    func toIndex() -> Int {
        switch self {
        case .krw:
            return 0
        case .usd:
            return 1
        }
    }
}
