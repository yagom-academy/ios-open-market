import UIKit

class MainViewController: UIViewController {
    
    private let segmentedControl: CustomSegmentedControl = {
        let items: [String] = ["List","Grid"]
        var segmented = CustomSegmentedControl(items: items)
        segmented.configureAttributes()
        return segmented
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isUserInteractionEnabled = false
        return scrollView
    }()

    private let listViewController: ListCollectionViewController = {
        let vc = ListCollectionViewController()
        vc.view.backgroundColor = .systemBlue
        return vc
    }()
    private let gridViewController: GridCollectionViewController = {
        let vc = GridCollectionViewController()
        vc.view.backgroundColor = .systemYellow
        return vc
    }()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureTargetAction()
    }
}

//MARK: - Layout
extension MainViewController {
    func configureLayout() {
        configureSegmentedControlLayout()
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.contentSize.width = view.frame.width * 2
        
        
        scrollView.addSubview(listViewController.view)
        listViewController.view.translatesAutoresizingMaskIntoConstraints = false
        listViewController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        listViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        listViewController.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        listViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(gridViewController.view)
        gridViewController.view.translatesAutoresizingMaskIntoConstraints = false
        gridViewController.view.leadingAnchor.constraint(equalTo: listViewController.view.trailingAnchor).isActive = true
        gridViewController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        gridViewController.view.widthAnchor.constraint(equalTo: listViewController.view.widthAnchor).isActive = true
        gridViewController.view.topAnchor.constraint(equalTo: listViewController.view.topAnchor).isActive = true
        gridViewController.view.bottomAnchor.constraint(equalTo: listViewController.view.bottomAnchor).isActive = true
    }
    
    private func configureSegmentedControlLayout() {
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
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

//MARK: - Segmented Control
extension MainViewController {
    func configureTargetAction() {
        segmentedControl.addTarget(self, action: #selector(touchUpListButton), for: .valueChanged)
    }
    
    @objc func touchUpListButton() {
        let destinationX: CGFloat = view.frame.width * CGFloat(segmentedControl.selectedSegmentIndex)
        let destinationPoint = CGPoint(x: destinationX, y: 0)
        
        scrollView.setContentOffset(destinationPoint, animated: true)
    }
}
