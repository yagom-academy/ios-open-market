import UIKit

class MainViewController: UIViewController {
    
    private let segmentedControl = CustomSegmentedControl()
    private var productRegistrationButtonItem: UIBarButtonItem!
    private let scrollView = UIScrollView()
    private let listViewController = ListCollectionViewController()
    private let gridViewController = GridCollectionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAllComponents()
        configureAttribute()
        configureLayout()
        fetchProductList()
    }
    
    private func createAllComponents() {
        createProductRegistrationButtonItem()
    }
    
    private func configureAttribute() {
        configureMainViewAttribute()
        configureSegmentedControlAttribute()
        configureProductRegistrationButtonItemAttribute()
        configureScrollViewAttribute()
        configureListViewControllerAttribute()
        configureGridViewControllerAttribute()
    }
    
    private func configureLayout() {
        configureMainViewLayout()
        configureSegmentedControlLayout()
        configureProductRegistrationButtonItemLayout()
        configureScrollViewLayout()
        configureListViewControllerLayout()
        configureGridViewControllerLayout()
    }
    
    //MARK: - MainView
    private func configureMainViewAttribute() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureMainViewLayout() {
        view.addSubview(scrollView)
    }
}

//MARK: - Segmented Control
extension MainViewController {
    
    private func configureSegmentedControlAttribute() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        let bounds = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width * 0.4 ,
            height: segmentedControl.bounds.height
        )
        segmentedControl.bounds = bounds
        navigationItem.titleView = segmentedControl
        
        segmentedControl.addTarget(self, action: #selector(touchUpListButton), for: .valueChanged)
    }
    
    private func configureSegmentedControlLayout() {
        
    }

    @objc func touchUpListButton() {
        let destinationX: CGFloat = view.frame.width * CGFloat(segmentedControl.selectedSegmentIndex)
        let destinationPoint = CGPoint(x: destinationX, y: 0)
        
        scrollView.setContentOffset(destinationPoint, animated: true)
    }
}

//MARK: - ProductRegistrationButtonItem
extension MainViewController {
    
    private func createProductRegistrationButtonItem() {
        productRegistrationButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(presentProductRegistrationViewController))
    }
    
    private func configureProductRegistrationButtonItemAttribute() {
        
    }
    
    private func configureProductRegistrationButtonItemLayout() {
        navigationItem.setRightBarButton(productRegistrationButtonItem, animated: true)
    }

    @objc private func presentProductRegistrationViewController() {
        let vc = ProductRegistrationViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

//MARK: - ScrollView
extension MainViewController: UIScrollViewDelegate {
    
    private func configureScrollViewAttribute() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
    }
    
    private func configureScrollViewLayout() {
        scrollView.addSubview(listViewController.view)
        scrollView.addSubview(gridViewController.view)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        scrollView.contentSize.width = view.frame.width * 2
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = Int(round(scrollView.contentOffset.x/scrollView.frame.width))
        guard pageNumber < segmentedControl.numberOfSegments else {
            return
        }
        segmentedControl.selectedSegmentIndex = pageNumber
    }
    
    override func viewDidLayoutSubviews() {
        let destinationX: CGFloat = view.frame.width * CGFloat(segmentedControl.selectedSegmentIndex)
        let destinationPoint = CGPoint(x: destinationX, y: 0)

        // animated: true에서 버그발생
        // Grid 뷰에서 Landscape Left -> Portrait 변경 시 scrollview offset이 제대로 잡히지 않음
        scrollView.setContentOffset(destinationPoint, animated: false)
    }
}

//MARK: - ListViewController
extension MainViewController {
    
    private func configureListViewControllerAttribute() {
        
    }
    
    private func configureListViewControllerLayout() {
        listViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            listViewController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            listViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            listViewController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            listViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - GridViewController
extension MainViewController {
    
    private func configureGridViewControllerAttribute() {
        
    }
    
    private func configureGridViewControllerLayout() {
        gridViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gridViewController.view.leadingAnchor.constraint(equalTo: listViewController.view.trailingAnchor),
            gridViewController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            gridViewController.view.widthAnchor.constraint(equalTo: listViewController.view.widthAnchor),
            gridViewController.view.topAnchor.constraint(equalTo: listViewController.view.topAnchor),
            gridViewController.view.bottomAnchor.constraint(equalTo: listViewController.view.bottomAnchor)
        ])
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
