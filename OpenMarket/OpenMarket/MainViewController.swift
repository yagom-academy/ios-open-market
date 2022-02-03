import UIKit
import JNomaKit

final class MainViewController: UIViewController {
    
    private var segmentedControl: JNSegmentedControl!
    private var productRegistrationButtonItem: UIBarButtonItem!
    private let scrollView = UIScrollView()
    private let listViewController = ListCollectionViewController()
    private let gridViewController = GridCollectionViewController()
    
    //MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        create()
        organizeViewHierarchy()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchProductList()
    }
    
    override func viewDidLayoutSubviews() {
        let destinationX: CGFloat = view.safeAreaLayoutGuide.layoutFrame.width * CGFloat(segmentedControl.selectedSegmentIndex)
        let destinationPoint = CGPoint(x: destinationX, y: 0)

        // animated: true에서 버그발생
        // Grid 뷰에서 Landscape Left -> Portrait 변경 시 scrollview offset이 제대로 잡히지 않음
        scrollView.setContentOffset(destinationPoint, animated: false)
    }
    
    func pushViewController(_ viewController: ProductDetailViewController, withProductId productId: Int) {
        viewController.productId = productId
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: - Private Method
extension MainViewController {
    private func create() {
        createSegmentedControl()
        createProductRegistrationButtonItem()
    }
    
    private func organizeViewHierarchy() {
        navigationItem.titleView = segmentedControl
        navigationItem.setRightBarButton(productRegistrationButtonItem, animated: true)
        
        view.addSubview(scrollView)
        scrollView.addSubview(listViewController.view)
        scrollView.addSubview(gridViewController.view)
    }
    
    private func configure() {
        configureMainView()
        configureSegmentedControl()
        configureScrollView()
        configureListViewController()
        configureGridViewController()
    }
    
    //MARK: - MainView
    private func configureMainView() {
        view.backgroundColor = .systemBackground
    }

    //MARK: - Segmented Control
    private func createSegmentedControl() {
        segmentedControl = JNSegmentedControl(items: ["List","Grid"], color: .systemBlue, textStyle: .caption1)
    }
    
    private func configureSegmentedControl() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        let bounds = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width * 0.4 ,
            height: segmentedControl.bounds.height
        )
        segmentedControl.bounds = bounds
        
        segmentedControl.addTarget(self, action: #selector(touchUpListButton), for: .valueChanged)
    }

    @objc func touchUpListButton() {
        let destinationX: CGFloat = view.safeAreaLayoutGuide.layoutFrame.width * CGFloat(segmentedControl.selectedSegmentIndex)
        let destinationPoint = CGPoint(x: destinationX, y: 0)
        
        scrollView.setContentOffset(destinationPoint, animated: true)
    }

    //MARK: - ProductRegistrationButtonItem
    private func createProductRegistrationButtonItem() {
        productRegistrationButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(presentProductRegistrationViewController)
        )
    }

    @objc private func presentProductRegistrationViewController() {
        let productRegistrationViewController = ProductRegistrationViewController()
        productRegistrationViewController.modalPresentationStyle = .fullScreen
        present(productRegistrationViewController, animated: true)
    }

    //MARK: - ScrollView
    private func configureScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        scrollView.contentSize.width = view.frame.width * 2
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = Int(round(scrollView.contentOffset.x/scrollView.frame.width))
        
        if pageNumber > segmentedControl.numberOfSegments {
            segmentedControl.selectedSegmentIndex = segmentedControl.numberOfSegments - 1
        } else {
            segmentedControl.selectedSegmentIndex = pageNumber
        }
    }

    //MARK: - ListViewController
    private func configureListViewController() {
        listViewController.viewTransitionDelegate = self
        listViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            listViewController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            listViewController.view.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            listViewController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            listViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    //MARK: - GridViewController
    private func configureGridViewController() {
        gridViewController.viewTransitionDelegate = self
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
                    print(OpenMarketError.decodingFail("Data", "NetworkingAPI.ProductListQuery"))
                    return
                }
                self.listViewController.applySnapShot(products: products)
                self.gridViewController.applySnapShot(products: products)
            case .failure(let error):
                print(error)
            }
        }
    }
}
