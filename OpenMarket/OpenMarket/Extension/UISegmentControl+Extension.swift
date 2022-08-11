import UIKit

extension UISegmentedControl {
    func setDefaultFontColor(_ color: UIColor = UIColor.white) {
        let defaultAttributes = [NSAttributedString.Key.foregroundColor: color]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }

    func setSelectedFontColor(_ color: UIColor = UIColor.red) {
        let selectedAttributes = [NSAttributedString.Key.foregroundColor: color]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}
