import UIKit

private enum Section: Hashable {
    case main
}

class ViewController: UIViewController {
    private var productListCollectionView: UICollectionView!
    private var productGridCollectionView: UICollectionView!
    private var segment: LayoutSegmentedControl!
    private var listDataSource: UICollectionViewDiffableDataSource<Section, ProductDetail>?
    private var gridDataSource: UICollectionViewDiffableDataSource<Section, ProductDetail>?
    private var productData: [ProductDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configSegmentedControl()
        configUI()
        fetchProductData()
    }

    private func fetchProductData() {
        let api = APIService()
        api.retrieveProductList(pageNo: 0, itemsPerPage: 3) { result in
            switch result {
            case .success(let data):
                self.productData = data.pages
                DispatchQueue.main.async {
                    self.setupListCollectionView()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configSegmentedControl() {
        segment = LayoutSegmentedControl(items: ["LIST", "GRID"])
        segment.addTarget(self, action: #selector(switchCollectionViewLayout), for: .valueChanged)
    }
    
    @objc func switchCollectionViewLayout() {
        if productGridCollectionView == nil {
            setupGridCollectionView()
        }
        
        if segment.selectedSegmentIndex == 0 {
            productListCollectionView.isHidden = false
            productGridCollectionView.isHidden = true
        } else {
            productListCollectionView.isHidden = true
            productGridCollectionView.isHidden = false
        }
    }

    private func configUI() {
        view.backgroundColor = .white
        configNavigationBar()
    }

    private func configNavigationBar() {
        self.navigationController?.navigationBar.topItem?.titleView = segment
    }
}

// MARK: - CustomListCollectionView

private extension ViewController {
    func setupListCollectionView() {
        configListCollectionView()
        configListDataSource()
    }
    
    func createListLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    func configListCollectionView() {
        productListCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        view.addSubview(productListCollectionView)
    }
    
    func configListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductListLayoutCell, ProductDetail> { cell, _, product in
            cell.updateWithProduct(from: product)
            cell.accessories = [.disclosureIndicator()]
        }
        
        listDataSource = UICollectionViewDiffableDataSource<Section, ProductDetail>(collectionView: productListCollectionView) { (collectionView, indexPath, product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductDetail>()
        snapshot.appendSections([.main])
        snapshot.appendItems(productData)
        listDataSource?.apply(snapshot)
    }
}

// MARK: - CustomGridCollectionView

extension ViewController {
    func setupGridCollectionView() {
        configGridCollectionView()
        configGridDataSource()
    }
    
    func createGridLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 15
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(self.view.frame.height * 0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(10)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configGridCollectionView() {
        productGridCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createGridLayout())
        view.addSubview(productGridCollectionView)
    }
    
    func configGridDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductGridLayoutCell, ProductDetail> { (cell, _, product) in
            cell.configUI(with: product)
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 1
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 10
        }
        
        gridDataSource = UICollectionViewDiffableDataSource<Section, ProductDetail>(collectionView: productGridCollectionView) { (collectionView, indexPath, product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductDetail>()
        snapshot.appendSections([.main])
        snapshot.appendItems(productData)
        gridDataSource?.apply(snapshot)
    }
}
