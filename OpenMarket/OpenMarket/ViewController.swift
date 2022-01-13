import UIKit

class ViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let apiManager = APIManager()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: OpenMarketViewLayout.grid)
    var dataSource: UICollectionViewDiffableDataSource<Section, ProductDetail>?
    var isListLayout = false
    
    override func loadView() {
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "ProductListCell", bundle: nil), forCellWithReuseIdentifier: ProductListCell.identifier)
        collectionView.register(UINib(nibName: "ProductGridCell", bundle: nil), forCellWithReuseIdentifier: ProductGridCell.identifier)
        setupCollectionView()
        getProducts()
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }
    
    func getProducts() {
        apiManager.checkProductList(pageNumber: 1, itemsPerPage: 20) { result in
            switch result {
            case .success(let products):
                self.populate(with: products.pages)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setupCollectionView() {
        dataSource = UICollectionViewDiffableDataSource<Section, ProductDetail>(collectionView: collectionView) { collectionView, indexPath, product in
            
            if self.isListLayout {
                return self.productListCell(indexPath: indexPath, with: product)
            }
            return self.productGridCell(indexPath: indexPath, with: product)
        }
    }
    
    func productListCell(indexPath: IndexPath, with product: ProductDetail) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCell.identifier, for: indexPath) as? ProductListCell else {
            return UICollectionViewListCell()
        }
        cell.setup(with: product)
        return cell
    }
    
    func productGridCell(indexPath: IndexPath, with product: ProductDetail) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductGridCell.identifier, for: indexPath) as? ProductGridCell else {
            return UICollectionViewListCell()
        }
        cell.setup(with: product)
        return cell
    }
    
    func populate(with products: [ProductDetail]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductDetail>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products)
        dataSource?.apply(snapshot)
    }
    
}
