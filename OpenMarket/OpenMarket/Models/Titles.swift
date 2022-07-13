enum Titles: Int, CaseIterable {
    case LIST
    case GRID
    
    static var toString: [String] {
        Titles.allCases.map { String(describing: $0) }
    }
}
