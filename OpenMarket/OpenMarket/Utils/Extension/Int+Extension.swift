import Foundation

extension Int {
    func format() -> String? {
        guard let formattedString = NumberFormatter.decimal.string(for: self) else {
            return nil
        }
        return formattedString
    }
}

extension Double {
    func format() -> String? {
        guard let formattedString = NumberFormatter.decimal.string(for: self) else {
            return nil
        }
        return formattedString
    }
}
