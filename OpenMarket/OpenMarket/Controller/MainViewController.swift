import UIKit

class MainViewController: UIViewController {
    @IBOutlet private weak var viewSegmentedControl: UISegmentedControl!
    
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
        let jsonParser: JSONParser = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
            let jsonParser = JSONParser(
                dateDecodingStrategy: .formatted(formatter),
                keyDecodingStrategy: .convertFromSnakeCase,
                keyEncodingStrategy: .convertToSnakeCase
            )
            return jsonParser
        }()
        let networkTask = NetworkTask(jsonParser: jsonParser)
        let viewController: UIViewController
        
        switch segment {
        case .list:
            viewController = makeProductsTableViewController(
                jsonParser: jsonParser,
                networkTask: networkTask
            )
        case .grid:
            viewController = makeProductsCollectionViewController(
                jsonParser: jsonParser,
                networkTask: networkTask
            )
        }
        return viewController
    }
    
    private func makeProductsTableViewController(
        jsonParser: JSONParser,
        networkTask: NetworkTask
    ) -> UIViewController {
        let storyboardName = ProductsTableViewController.listViewStoryboardName
        let controllerIdentifier = ProductsTableViewController.listViewControllerIdentifier
        
        let listViewStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = listViewStoryboard.instantiateViewController(
            identifier: controllerIdentifier
        ) { coder in
            let productsTableViewController = ProductsTableViewController(
                coder: coder,
                jsonParser: jsonParser,
                networkTask: networkTask
            )
            return productsTableViewController
        }
        return viewController
    }
    
    private func makeProductsCollectionViewController(
        jsonParser: JSONParser,
        networkTask: NetworkTask
    ) -> UIViewController {
        let storyboardName = ProductsCollectionViewController.gridViewStoryboardName
        let controllerIdentifier = ProductsCollectionViewController.gridViewControllerIdentifier
        
        let gridViewStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = gridViewStoryboard.instantiateViewController(
            identifier: controllerIdentifier
        ) { coder in
            let productsCollectionViewController = ProductsCollectionViewController(
                coder: coder,
                jsonParser: jsonParser,
                networkTask: networkTask
            )
            return productsCollectionViewController
        }
        return viewController
    }
}
