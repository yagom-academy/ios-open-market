import Foundation

extension Double {
    func formattedNumber() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(for: self) ?? ""
    }
}
