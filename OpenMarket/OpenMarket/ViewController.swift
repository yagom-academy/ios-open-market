import UIKit

@available(iOS 14.0, *)
class ViewController: UIViewController {
    enum Section: CaseIterable {
        case main
    }
    
    @IBOutlet weak var segment: SegmentedControl!
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var gridCollectionView: UICollectionView!
    
    var productList = [ProductInformation](){
        didSet {
            applySnapShot()
        }
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, ProductInformation>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSegmentedControl()
        getData()
        setUpCell()
        applySnapShot(animatingDifferences: false)
    }
    
    func setSegmentedControl() {
        self.navigationItem.titleView = segment
        segment.setUpUI()
    }
    
    @IBAction func changeView(_ sender: SegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            listCollectionView.isHidden = false
            gridCollectionView.isHidden = true
        case 1:
            listCollectionView.isHidden = true
            gridCollectionView.isHidden = false
        default:
            break
        }
    }
    
    func getData() {
        let api = APIManager()
        api.requestProductList(pageNumber: 1, itemsPerPage: 20) { result in
            switch result {
            case .success(let data):
                self.productList = data.pages
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setUpCell() {
        let cellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell, ProductInformation> { cell, indexpath, product in
            
            cell.productImageView.image = UIImage(data: try! Data(contentsOf: URL(string: product.thumbnail)!))
            cell.productNameLabel.text = product.name
            cell.stockLabel.text = String(product.stock)
            cell.priceLabel.text = String(product.price)
            cell.discountedPriceLabel.text = String(product.discountedPrice)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, ProductInformation>(collectionView: listCollectionView, cellProvider: { (collectionView, indexPath, product) -> ListCollectionViewCell in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
            
            return cell
        })
    }
    
    func applySnapShot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductInformation>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(productList)
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
