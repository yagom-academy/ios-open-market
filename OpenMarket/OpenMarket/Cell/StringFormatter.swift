
import Foundation

extension Int {
    func distinguishNumberUnit() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let changedUnit = numberFormatter.string(from: NSNumber(value: self)) else {
            return ""
        }
        return changedUnit
    }
}
