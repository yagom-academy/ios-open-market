import UIKit

class OpenMarketViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let apiManager = APIManager()
    let listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: OpenMarketViewLayout.list)
    let gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: OpenMarketViewLayout.grid)
    var listDataSource: UICollectionViewDiffableDataSource<Section, ProductDetail>?
    var gridDataSource: UICollectionViewDiffableDataSource<Section, ProductDetail>?
    
    override func loadView() {
        view = listCollectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        registerCollectionViewCell()
        setupListCollectionView()
        setupGridCollectionView()
        getProducts()
    }
    
    func setupSegmentedControl() {
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }
    
    func registerCollectionViewCell() {
        listCollectionView.register(UINib(nibName: "ProductListCell", bundle: nil), forCellWithReuseIdentifier: ProductListCell.identifier)
        gridCollectionView.register(UINib(nibName: "ProductGridCell", bundle: nil), forCellWithReuseIdentifier: ProductGridCell.identifier)
    }
    
    func setupListCollectionView() {
        listDataSource = UICollectionViewDiffableDataSource<Section, ProductDetail>(collectionView: listCollectionView) { collectionView, indexPath, product in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCell.identifier, for: indexPath) as? ProductListCell else {
                return UICollectionViewListCell()
            }
            cell.setup(with: product)
            return cell
        }
    }
    
    func setupGridCollectionView() {
        gridDataSource = UICollectionViewDiffableDataSource<Section, ProductDetail>(collectionView: gridCollectionView) { collectionView, indexPath, product in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductGridCell.identifier, for: indexPath) as? ProductGridCell else {
                return UICollectionViewListCell()
            }
            cell.setup(with: product)
            return cell
        }
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
    
    func populate(with products: [ProductDetail]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductDetail>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products)
        listDataSource?.apply(snapshot)
        gridDataSource?.apply(snapshot)
    }
    
    @IBAction func segementChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            view = listCollectionView
        case 1:
            view = gridCollectionView
        default:
            return
        }
    }
    
}
