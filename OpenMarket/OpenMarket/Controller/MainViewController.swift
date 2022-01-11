import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var viewSegmetedControl: UISegmentedControl!
    let listViewControllerIdentifier = "ListViewController"
    let gridViewControllerIdentifier = "GridViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewController()
    }
    
    private func loadViewController() {
        children.forEach { children in
            children.removeFromParent()
        }
        if viewSegmetedControl.selectedSegmentIndex == 0 {
            guard let controller = storyboard?.instantiateViewController(withIdentifier: listViewControllerIdentifier) else { return }
            addChild(controller)
            view.addSubview(controller.view)
        } else if viewSegmetedControl.selectedSegmentIndex == 1 {
            guard let controller = storyboard?.instantiateViewController(withIdentifier: gridViewControllerIdentifier) else { return }
            addChild(controller)
            view.addSubview(controller.view)
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        loadViewController()
    }
}
