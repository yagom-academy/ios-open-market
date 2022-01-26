import Foundation

extension Double {
    func addDemical() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let result = numberFormatter.string(from: NSNumber(value: self)) else {
            return ""
        }
        
        return result
    }
}
