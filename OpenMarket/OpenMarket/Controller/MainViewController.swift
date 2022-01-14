import UIKit

class MainViewController: UIViewController {
    @IBOutlet private weak var viewSegmentedControl: UISegmentedControl!
    private let listViewStoryboardName = "ProductsTableView"
    private let gridViewStoryboardName = "ProductsCollectionView"
    private let listViewControllerIdentifier = "ListViewController"
    private let gridViewControllerIdentifier = "GridViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        changeSubviewController()
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
    
    private func changeSubviewController() {
        guard let selectedSegment = Segement(
            rawValue: viewSegmentedControl.selectedSegmentIndex
        ) else { return }
        let viewController = loadViewController(from: selectedSegment)
        
        removeChildren()
        addChild(viewController)
        view.addSubview(viewController.view)
    }
    
    @IBAction private func segmentedControlChanged(_ sender: UISegmentedControl) {
        changeSubviewController()
    }
}

extension MainViewController {
     private enum Segement: Int {
        case list
        case grid
    }
    
    private func removeChildren() {
        children.forEach { children in
            children.removeFromParent()
        }
        view.subviews.forEach { subView in
            subView.removeFromSuperview()
        }
    }
    
    private func loadViewController(from segment: Segement) -> UIViewController {
        let viewController: UIViewController
        switch segment {
        case .list:
            let listViewStoryboard = UIStoryboard(name: listViewStoryboardName, bundle: nil)
            viewController = listViewStoryboard.instantiateViewController(
                withIdentifier: listViewControllerIdentifier
            )
        case .grid:
            let gridViewStoryboard = UIStoryboard(name: gridViewStoryboardName, bundle: nil)
            viewController = gridViewStoryboard.instantiateViewController(
                withIdentifier: gridViewControllerIdentifier
            )
        }
        return viewController
    }
}
