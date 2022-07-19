import UIKit

extension UISegmentedControl {
    func defaultConfiguration(color: UIColor = UIColor.white) {
        let defaultAttributes = [
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }

    func selectedConfiguration(color: UIColor = UIColor.red) {
        let selectedAttributes = [
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}
