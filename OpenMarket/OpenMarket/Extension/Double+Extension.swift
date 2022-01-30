import Foundation

extension Double {
    func demical() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let result = numberFormatter.string(from: NSNumber(value: self)) else {
            return ""
        }
        
        return result
    }
}
