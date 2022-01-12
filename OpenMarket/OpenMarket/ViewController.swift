import UIKit

class ViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let apiManager = APIManager()
    let collectionView = ProductListView()
    var dataSource: UICollectionViewDiffableDataSource<Section, ProductDetail>?
    
    override func loadView() {
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "ProductListCell", bundle: nil), forCellWithReuseIdentifier: ProductListCell.identifier)
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
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCell.identifier, for: indexPath) as? ProductListCell else {
                return UICollectionViewListCell()
            }
            cell.setup(with: product)
            return cell
        }
    }
    
    func populate(with products: [ProductDetail]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductDetail>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products)
        dataSource?.apply(snapshot)
    }
    
}
