import UIKit

class MainViewController: UIViewController {
    
    private let segmentedControl = CustomSegmentedControl()
    private var productRegistrationButton: UIBarButtonItem!
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let listViewController = ListCollectionViewController()
    private let gridViewController = GridCollectionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAllComponents()
        configureMainViewAttribute()
        configureLayout()
        configureUserInteraction()
        fetchProductList()
    }
    
    private func createAllComponents() {
        createProductRegistrationButton()
    }
    
    private func configureMainViewAttribute() {
        view.backgroundColor = .systemBackground
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

//MARK: - User Interaction
extension MainViewController: UIScrollViewDelegate {
    
    func configureUserInteraction() {
        segmentedControl.addTarget(self, action: #selector(touchUpListButton), for: .valueChanged)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = Int(round(scrollView.contentOffset.x/scrollView.frame.width))
        guard pageNumber < segmentedControl.numberOfSegments else {
            return
        }
        segmentedControl.selectedSegmentIndex = pageNumber
    }
    
    @objc func touchUpListButton() {
        let destinationX: CGFloat = view.frame.width * CGFloat(segmentedControl.selectedSegmentIndex)
        let destinationPoint = CGPoint(x: destinationX, y: 0)
        
        scrollView.setContentOffset(destinationPoint, animated: true)
    }
}

//MARK: - Networking
extension MainViewController {
    
    private func fetchProductList() {
        NetworkingAPI.ProductListQuery.request(session: URLSession.shared,
                                               pageNo: 1,
                                               itemsPerPage: 30) { result in
  
            switch result {
            case .success(let data):
                guard let products = NetworkingAPI.ProductListQuery.decode(data: data)?.pages else {
                    return
                }
                self.listViewController.applySnapShot(products: products)
                self.gridViewController.applySnapShot(products: products)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension MainViewController {
    
    override func viewDidLayoutSubviews() {
        let destinationX: CGFloat = view.frame.width * CGFloat(segmentedControl.selectedSegmentIndex)
        let destinationPoint = CGPoint(x: destinationX, y: 0)

        // animated: true에서 버그발생
        // Grid 뷰에서 Landscape Left -> Portrait 변경 시 scrollview offset이 제대로 잡히지 않음
        scrollView.setContentOffset(destinationPoint, animated: false)
    }
}

//MARK: - ProductRegistrationButton
extension MainViewController {
    
    private func createProductRegistrationButton() {
        productRegistrationButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(presentProductRegistrationViewController))
        navigationItem.setRightBarButton(productRegistrationButton, animated: true)
    }

    @objc private func presentProductRegistrationViewController() {
        let vc = ProductRegistrationViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
