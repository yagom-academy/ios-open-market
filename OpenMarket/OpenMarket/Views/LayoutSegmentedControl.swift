import UIKit

class LayoutSegmentedControl: UISegmentedControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(items: [String]) {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        configUI(with: items)
    }
    
    func configUI(with items: [String]) {
        items.enumerated().forEach { (index, item) in
            insertSegment(withTitle: item, at: index, animated: true)
        }
        
        selectedSegmentIndex = 0
        selectedSegmentTintColor = UIColor.systemBlue
        layer.borderColor = UIColor.systemBlue.cgColor
        layer.borderWidth = 2
        setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)    }
}
