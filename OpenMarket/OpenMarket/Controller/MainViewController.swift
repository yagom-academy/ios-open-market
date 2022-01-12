import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var viewSegmentedControl: UISegmentedControl!
    let listViewControllerIdentifier = "ListViewController"
    let gridViewControllerIdentifier = "GridViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        loadViewController()
    }
    
    private func setupSegmentedControl() {
        viewSegmentedControl.selectedSegmentTintColor = .systemBlue
        viewSegmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        viewSegmentedControl.layer.borderWidth = 1.0
        viewSegmentedControl.setTitleTextAttributes(
            [.foregroundColor: UIColor.white],
            for: .selected
        )
        viewSegmentedControl.setTitleTextAttributes(
            [.foregroundColor: UIColor.systemBlue],
            for: .normal
        )
    }
    
    private func loadViewController() {
        children.forEach { children in
            children.removeFromParent()
        }
        view.subviews.forEach { subView in
            subView.removeFromSuperview()
        }
        if viewSegmentedControl.selectedSegmentIndex == 0 {
            guard let listViewController = storyboard?.instantiateViewController(
                withIdentifier: listViewControllerIdentifier
            ) else { return }
            addChild(listViewController)
            view.addSubview(listViewController.view)
        } else if viewSegmentedControl.selectedSegmentIndex == 1 {
            guard let gridViewController = storyboard?.instantiateViewController(
                withIdentifier: gridViewControllerIdentifier
            ) else { return }
            addChild(gridViewController)
            view.addSubview(gridViewController.view)
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        loadViewController()
    }
}
