import UIKit

class ProductListViewController: UIViewController {

     let segmentedControl: UISegmentedControl = {
        let items: [String] = ["List","Grid"]
        var segmented = UISegmentedControl(items: items)
         
        segmented.layer.cornerRadius = 4
        segmented.layer.borderWidth = 1
        segmented.layer.borderColor = UIColor.systemBlue.cgColor
        segmented.selectedSegmentTintColor = .white
        segmented.backgroundColor = .systemBlue
        let selectedAttribute: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.systemBlue]
        segmented.setTitleTextAttributes(selectedAttribute, for: .selected)
        let normalAttribute: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.white]
        segmented.setTitleTextAttributes(normalAttribute, for: .normal)
        segmented.selectedSegmentIndex = 0
        return segmented
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationItems()
    }
    
    func configureNavigationItems() {
        let bounds = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width * 0.4 ,
            height: segmentedControl.bounds.height
        )
        segmentedControl.bounds = bounds
        navigationItem.titleView = segmentedControl
    }

}
    

