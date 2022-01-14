import UIKit

class ProductListViewController: UIViewController {
    enum Section: Hashable {
        case list
        case grid
    }
    
    var products: ProductListAsk.Response?
    lazy var collectionView = UICollectionView(
        frame: view.bounds,
        collectionViewLayout: makeListLayout()
    )
    var dataSource: UICollectionViewDiffableDataSource<Section, ProductListAsk.Response.Page>!
    
    let segmentedControl: UISegmentedControl = {
        let items: [String] = ["List","Grid"]
        var segmented = UISegmentedControl(items: items)
         
        segmented.layer.cornerRadius = 4
        segmented.layer.borderWidth = 1
        segmented.layer.borderColor = UIColor.systemBlue.cgColor
        segmented.selectedSegmentTintColor = .white
        segmented.backgroundColor = .systemBlue
        let selectedAttribute: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.systemBlue]
        segmented.setTitleTextAttributes(selectedAttribute, for: .selected)
        let normalAttribute: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.white]
        segmented.setTitleTextAttributes(normalAttribute, for: .normal)
        segmented.selectedSegmentIndex = 0
        return segmented
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationItems()
        view.addSubview(collectionView)
        fetchProductList()
        configureListDataSource()
        segmentedControl.addTarget(self, action: #selector(touchUpListButton), for: .valueChanged)
    }
    
    func configureNavigationItems() {
        let bounds = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width * 0.4 ,
            height: segmentedControl.bounds.height
        )
        segmentedControl.bounds = bounds
        navigationItem.titleView = segmentedControl
    }
    
    func makeGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.3)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func makeListLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (section, layoutEnvironment) in
            let appearance = UICollectionLayoutListConfiguration.Appearance.plain
            let configuration = UICollectionLayoutListConfiguration(appearance: appearance)
            
            return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
        }
    }
    
    func configureListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CollectionViewListCell, ProductListAsk.Response.Page> {
            (cell, indexPath, item) in
        }
      
        dataSource = UICollectionViewDiffableDataSource<Section, ProductListAsk.Response.Page>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
            print("item:\(indexPath.item)")
// TODO: cell.image load
            cell.activityIndicator.stopAnimating()
            cell.nameLabel.text = item.name
            cell.priceLabel.text = item.price.description
            cell.stockLabel.text = item.stock.description
            return cell
        }
        applySnapShot(section: .list)
    }
    
    func configureGridDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CollectionViewGridCell, ProductListAsk.Response.Page> {
            (cell, indexPath, item) in
        }
      
        dataSource = UICollectionViewDiffableDataSource<Section, ProductListAsk.Response.Page>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
            print("item:\(indexPath.item)")
// TODO: cell.image load
            cell.activityIndicator.stopAnimating()
            cell.nameLabel.text = item.name
            cell.priceLabel.text = item.price.description
            cell.stockLabel.text = item.stock.description
            return cell 
        }
        applySnapShot(section: .grid)
    }
    
    func applySnapShot(section: Section) {
        guard let products = products else {
            return
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductListAsk.Response.Page>()
        snapshot.appendSections([section])
        snapshot.appendItems(products.pages)
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }

    func fetchProductList() {
        let requester = ProductListAskRequester(pageNo: 1, itemsPerPage: 15)
        URLSession.shared.request(requester: requester) { result in
            switch result {
            case .success(let data):
                guard let products = requester.decode(data: data) else {
                    print(APIError.decodingFail.localizedDescription)
                    return
                }
                self.products = products
                let section: Section = self.segmentedControl.selectedSegmentIndex == 0 ? .list : .grid
                self.applySnapShot(section: section)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - Segmented Control
extension ProductListViewController {
    @objc func touchUpListButton() {
        if segmentedControl.selectedSegmentIndex == 0 {
            collectionView.collectionViewLayout = makeListLayout()
            configureListDataSource()
        } else if segmentedControl.selectedSegmentIndex == 1 {
            collectionView.collectionViewLayout = makeGridLayout()
            configureGridDataSource()
        }
    }
}
