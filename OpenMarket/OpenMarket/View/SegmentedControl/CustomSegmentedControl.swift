import UIKit

class CustomSegmentedControl: UISegmentedControl {
    
    override init(items: [Any]?) {
        super.init(items: items)
    }
    
    convenience init() {
        let items: [String] = ["List","Grid"]
        self.init(items: items)
        configureAttributes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
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
