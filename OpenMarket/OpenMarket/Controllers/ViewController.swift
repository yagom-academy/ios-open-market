import UIKit

class ViewController: UIViewController {
    
    var segmentControl: UISegmentedControl?
    
    override func loadView() {
        view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegmentControl()
    }
}

extension ViewController {
    private func configureSegmentControl() {
        segmentControl = UISegmentedControl(items: Titles.toString)
        segmentControl?.selectedSegmentIndex = Titles.LIST.rawValue
        navigationItem.titleView = segmentControl
    }
}
