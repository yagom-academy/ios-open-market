import UIKit

class LayoutSegmentedControl: UISegmentedControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(items: [String]) {
        super.init(frame: CGRect(x: 0, y: 0, width: 180, height: 35))
        configUI(with: items)
    }
    
    private func configUI(with items: [String]) {
        items.enumerated().forEach { (index, item) in
            insertSegment(withTitle: item, at: index, animated: true)
        }
        
        selectedSegmentIndex = 0
    }
}
