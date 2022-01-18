import Foundation

extension Double {
    func addComma() -> String {
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        let convertedNumber = numberformatter.string(for: self) ?? ""
        return convertedNumber
    }
}
