import Foundation

extension Double {
    var formattedToDecimal: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        return formatter.string(for: self)
    }
}
