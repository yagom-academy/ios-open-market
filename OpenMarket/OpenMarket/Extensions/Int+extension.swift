import Foundation

extension Int {
    func addComma() -> String {
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        let convertedNumber = numberformatter.string(for: self) ?? ""
        return convertedNumber
    }
}
