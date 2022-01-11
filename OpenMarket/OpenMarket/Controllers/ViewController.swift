import UIKit

private enum Section: Hashable {
    case main
}

class ViewController: UIViewController {
    private var productCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, ProductDetail>?
    private var productData: [ProductDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func configUI() {
        view.backgroundColor = .white
        configNavigationBar()
    }

    private func configNavigationBar() {
        let segment = LayoutSegmentedControl(items: ["LIST", "GRID"])
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
        productCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        view.addSubview(productCollectionView)
    }
    
    func configListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductListLayoutCell, ProductDetail> { cell, _, product in
            cell.updateWithProduct(from: product)
            cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, ProductDetail>(collectionView: productCollectionView) { (collectionView, indexPath, product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductDetail>()
        snapshot.appendSections([.main])
        snapshot.appendItems(productData)
        dataSource?.apply(snapshot)
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
        productCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createGridLayout())
        view.addSubview(productCollectionView)
    }
    
    func configGridDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductGridLayoutCell, ProductDetail> { (cell, _, product) in
            cell.configUI(with: product)
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 1
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 10
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, ProductDetail>(collectionView: productCollectionView) { (collectionView, indexPath, product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductDetail>()
        snapshot.appendSections([.main])
        snapshot.appendItems(productData)
        dataSource?.apply(snapshot)
    }
}
