import Foundation

extension Int {
    func format() -> String {
        guard let formattedString = NumberFormatter.decimal.string(for: self) else {
            return ""
        }
        return formattedString
    }
}

extension Double {
    func format() -> String {
        guard let formattedString = NumberFormatter.decimal.string(for: self) else {
            return ""
        }
        return formattedString
    }
}
