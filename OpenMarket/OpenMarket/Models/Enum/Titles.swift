enum Titles: Int, CaseIterable {
    case list
    case grid
    
    static var toString: [String] {
        Titles.allCases.map { String(describing: $0).uppercased() }
    }
}
