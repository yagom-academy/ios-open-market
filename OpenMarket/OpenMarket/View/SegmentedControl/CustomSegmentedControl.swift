import UIKit

class CustomSegmentedControl: UISegmentedControl {
    
    func configureAttributes() {
        self.layer.cornerRadius = 4.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.selectedSegmentTintColor = .white
        self.backgroundColor = .systemBlue
        let selectedAttribute: [NSAttributedString.Key : UIColor] = [.foregroundColor : .systemBlue]
        self.setTitleTextAttributes(selectedAttribute, for: .selected)
        let normalAttribute: [NSAttributedString.Key : UIColor] = [.foregroundColor : .white]
        self.setTitleTextAttributes(normalAttribute, for: .normal)
        self.selectedSegmentIndex = 0
    }
}
