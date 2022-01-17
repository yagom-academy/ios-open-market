import UIKit

class ProductListViewController: UIViewController {

    private enum Section: Hashable {
        case list
        case grid
    }
    
    private var products: ProductListAsk.Response?
    private lazy var collectionView = UICollectionView(
        frame: view.bounds,
        collectionViewLayout: makeListLayout()
    )
    private var dataSource: UICollectionViewDiffableDataSource<Section, ProductListAsk.Response.Page>!
    
    private let segmentedControl: UISegmentedControl = {
        let items: [String] = ["List","Grid"]
        var segmented = UISegmentedControl(items: items)
        segmented.layer.cornerRadius = SegmentedControl.cornerRadius
        segmented.layer.borderWidth = SegmentedControl.borderWidth
        segmented.layer.borderColor = SegmentedControl.borderColor
        segmented.selectedSegmentTintColor = SegmentedControl.selectedSegmentTintColor
        segmented.backgroundColor = SegmentedControl.backgroundColor
        let selectedAttribute: [NSAttributedString.Key : Any] = [.foregroundColor : SegmentedControl.selectedColor]
        segmented.setTitleTextAttributes(selectedAttribute, for: .selected)
        let normalAttribute: [NSAttributedString.Key : Any] = [.foregroundColor : SegmentedControl.normalColor]
        segmented.setTitleTextAttributes(normalAttribute, for: .normal)
        segmented.selectedSegmentIndex = SegmentedControl.defaultSelectedSegmentIndex
        return segmented
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainView()
        configureCollectionView()
    }
    
    private func configureMainView() {
        view.backgroundColor = .white
        configureNavigationItems()
        segmentedControl.addTarget(self, action: #selector(touchUpListButton), for: .valueChanged)
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        fetchProductList()
        configureListDataSource()
    }

    private func configureNavigationItems() {
        let bounds = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width * 0.4 ,
            height: segmentedControl.bounds.height
        )
        segmentedControl.bounds = bounds
        navigationItem.titleView = segmentedControl
    }
    
    private func makeGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(CollectionView.Grid.Group.fractionalHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: CollectionView.Grid.Group.itemsPerGroup
        )
        group.interItemSpacing = .fixed(CollectionView.Grid.Item.spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CollectionView.Grid.Item.spacing
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func makeListLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (section, layoutEnvironment) in
            let appearance = UICollectionLayoutListConfiguration.Appearance.plain
            let configuration = UICollectionLayoutListConfiguration(appearance: appearance)
            
            return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
        }
    }
    
    private func configureListDataSource() {
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
            cell.updateAllComponents(from: item)
            cell.accessories = [.disclosureIndicator()]
            
            return cell
        }
        applySnapShot(section: .list)
    }
    
    private func configureGridDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CollectionViewGridCell, ProductListAsk.Response.Page> {
            (cell, indexPath, item) in
            cell.layer.borderColor = CollectionView.Grid.Item.borderColor
            cell.layer.borderWidth = CollectionView.Grid.Item.borderWidth
            cell.layer.cornerRadius = CollectionView.Grid.Item.cornerRadius
        }
      
        dataSource = UICollectionViewDiffableDataSource<Section, ProductListAsk.Response.Page>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
            cell.updateAllComponents(from: item)
            return cell 
        }
        applySnapShot(section: .grid)
    }
    
    private func applySnapShot(section: Section) {
        guard let products = products else {
            return
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductListAsk.Response.Page>()
        snapshot.appendSections([section])
        snapshot.appendItems(products.pages)
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func fetchProductList() {
        let requester = ProductListAskRequester(pageNo: 1, itemsPerPage: 30)
        URLSession.shared.request(requester: requester) { result in
            switch result {
            case .success(let data):
                guard let products = requester.decode(data: data) else {
                    print(APIError.decodingFail.localizedDescription)
                    return
                }
                self.products = products
                DispatchQueue.main.async {
                    let section: Section = self.segmentedControl.selectedSegmentIndex == 0 ? .list : .grid
                    self.applySnapShot(section: section)
                }
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

//MARK: - Layout 상수
extension ProductListViewController {
    enum CollectionView {
        enum Grid {
            enum Group {
                static let fractionalHeight = 0.3
                static let itemsPerGroup = 2
            }
            enum Item {
                static let spacing = 10.0
                static let borderColor = UIColor.systemGray.cgColor
                static let borderWidth = 1.0
                static let cornerRadius = 15.0
            }
        }
    }
    enum SegmentedControl {
        static let cornerRadius = 4.0
        static let borderWidth = 1.0
        static let borderColor = UIColor.systemBlue.cgColor
        static let selectedSegmentTintColor = UIColor.white
        static let backgroundColor = UIColor.systemBlue
        static let selectedColor = UIColor.systemBlue
        static let normalColor = UIColor.white
        static let defaultSelectedSegmentIndex = 0
    }
}
