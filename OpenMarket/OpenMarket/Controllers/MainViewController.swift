import UIKit

private enum ProductSection: Hashable {
    case main
}

class MainViewController: UIViewController {
    private var productListCollectionView: UICollectionView!
    private var productGridCollectionView: UICollectionView!
    private var layoutSegmentedControl: LayoutSegmentedControl!
    private var listDataSource: UICollectionViewDiffableDataSource<ProductSection, ProductDetail>?
    private var gridDataSource: UICollectionViewDiffableDataSource<ProductSection, ProductDetail>?
    private var productData: [ProductDetail] = []
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.center = view.center
        indicator.style = .large
        indicator.color = .black
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configSegmentedControl()
        configUI()
        fetchProductData()
    }

    private func fetchProductData() {
        activityIndicator.startAnimating()
        
        let api = APIService()
        api.retrieveProductList(pageNo: 1, itemsPerPage: 30) { result in
            switch result {
            case .success(let data):
                self.productData = data.pages
                DispatchQueue.main.async {
                    self.setupListCollectionView()
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configSegmentedControl() {
        layoutSegmentedControl = LayoutSegmentedControl(items: ["LIST", "GRID"])
        layoutSegmentedControl.addTarget(self, action: #selector(switchCollectionViewLayout), for: .valueChanged)
    }
    
    @objc private func switchCollectionViewLayout() {
        if productGridCollectionView == nil {
            setupGridCollectionView()
        }
        
        if layoutSegmentedControl.selectedSegmentIndex == 0 {
            productListCollectionView.isHidden = false
            productGridCollectionView.isHidden = true
            return
        }
        productListCollectionView.isHidden = true
        productGridCollectionView.isHidden = false
    }

    private func configUI() {
        view.backgroundColor = .white
        view.addSubview(activityIndicator)
        configNavigationBar()
    }

    private func configNavigationBar() {
        self.navigationItem.titleView = layoutSegmentedControl
        let plusImage = UIImage(systemName: "plus")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(presentProductRegisterView))
    }
    
    @objc private func presentProductRegisterView() {
        let destination = ProductRegisterViewController()
        self.present(destination, animated: true, completion: nil)
    }
    
    private func configCollectionViewLayout(_ collectionView: UICollectionView) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

// MARK: - Custom List CollectionView

private extension MainViewController {
    func setupListCollectionView() {
        configListCollectionView()
        configListDataSource()
    }
    
    func createListLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    func configListCollectionView() {
        productListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createListLayout())
        view.addSubview(productListCollectionView)
        configCollectionViewLayout(productListCollectionView)
    }
    
    func configListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductListLayoutCell, ProductDetail> { cell, _, product in
            cell.updateWithProduct(from: product)
            cell.accessories = [.disclosureIndicator()]
        }
        
        listDataSource = UICollectionViewDiffableDataSource<ProductSection, ProductDetail>(collectionView: productListCollectionView) { (collectionView, indexPath, product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<ProductSection, ProductDetail>()
        snapshot.appendSections([.main])
        snapshot.appendItems(productData)
        listDataSource?.apply(snapshot)
    }
}

// MARK: - Custom Grid CollectionView

private extension MainViewController {
    func setupGridCollectionView() {
        configGridCollectionView()
        configGridDataSource()
    }
    
    func createGridLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 15
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(self.view.frame.height * 0.35))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(10)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configGridCollectionView() {
        productGridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createGridLayout())
        view.addSubview(productGridCollectionView)
        configCollectionViewLayout(productGridCollectionView)
    }
    
    func configGridDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductGridLayoutCell, ProductDetail> { (cell, _, product) in
            cell.configUI(with: product)
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 1
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 10
        }
        
        gridDataSource = UICollectionViewDiffableDataSource<ProductSection, ProductDetail>(collectionView: productGridCollectionView) { (collectionView, indexPath, product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<ProductSection, ProductDetail>()
        snapshot.appendSections([.main])
        snapshot.appendItems(productData)
        gridDataSource?.apply(snapshot)
    }
}
