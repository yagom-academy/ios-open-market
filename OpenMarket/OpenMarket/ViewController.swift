import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var segment: SegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSegmentedControl()
    }

    func setSegmentedControl() {
        self.navigationItem.titleView = segment
        segment.setUpUI()
    }
}
