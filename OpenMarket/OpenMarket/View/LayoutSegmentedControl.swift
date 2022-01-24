import UIKit

class LayoutSegmentedControl: UISegmentedControl {
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func setUpUI() {
        let items = ["LIST","GRID"]
        
        items.enumerated().forEach { (index, title) in
            setTitle(title, forSegmentAt: index)
        }

        layer.borderColor = UIColor.systemBlue.cgColor
        layer.borderWidth = 2
        selectedSegmentTintColor = UIColor.systemBlue
        selectedSegmentIndex = 0
        setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
}
