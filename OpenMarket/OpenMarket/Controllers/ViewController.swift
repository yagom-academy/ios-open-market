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
        confingDataSource()
    }
    
    func createListLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    func configListCollectionView() {
        productCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        view.addSubview(productCollectionView)
    }
    
    func confingDataSource() {
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
