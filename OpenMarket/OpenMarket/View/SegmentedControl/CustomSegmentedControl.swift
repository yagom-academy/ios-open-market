import UIKit

class CustomSegmentedControl: UISegmentedControl {
    
    enum LayoutAttribute {
        static let cornerRadius: CGFloat = 4
        static let borderWidth: CGFloat = 1
        static let borderColor: CGColor = UIColor.systemBlue.cgColor
        static let selectedSegmentTintColor: UIColor = .white
        static let backgroundColor: UIColor = .systemBlue
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init() {
        let items: [String] = ["List","Grid"]
        self.init(items: items)
        
        configure()
    }
    
    private func configure() {
        let selectedAttribute: [NSAttributedString.Key : UIColor] = [.foregroundColor : .systemBlue]
        setTitleTextAttributes(selectedAttribute, for: .selected)
        let normalAttribute: [NSAttributedString.Key : UIColor] = [.foregroundColor : .white]
        setTitleTextAttributes(normalAttribute, for: .normal)
        
        layer.cornerRadius = LayoutAttribute.cornerRadius
        layer.borderWidth = LayoutAttribute.borderWidth
        layer.borderColor = LayoutAttribute.borderColor
        selectedSegmentTintColor = LayoutAttribute.selectedSegmentTintColor
        backgroundColor = LayoutAttribute.backgroundColor
        selectedSegmentIndex = 0
    }
}
