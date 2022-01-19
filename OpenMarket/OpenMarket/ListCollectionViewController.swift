import UIKit

class ListCollectionViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCollectionView()
        configureLayout()
    }
    
    private func createCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createdListLayout())
        dataSource = createdListDataSource()
    }
}

//MARK: - Layout
extension ListCollectionViewController {
    private func configureLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func createdListLayout() -> UICollectionViewCompositionalLayout {
        let layout =  UICollectionViewCompositionalLayout { (section, layoutEnvironment) in
            let appearance = UICollectionLayoutListConfiguration.Appearance.plain
            let configuration = UICollectionLayoutListConfiguration(appearance: appearance)
            
            return NSCollectionLayoutSection.list(using: configuration,
                                                  layoutEnvironment: layoutEnvironment)
        }
        
        return layout
    }
}

//MARK: - CollectionView Data Soruce
extension ListCollectionViewController {
    typealias Product = NetworkingAPI.ProductListQuery.Response.Page

    private enum Section: Hashable {
        case main
    }

    private func createdListDataSource() -> UICollectionViewDiffableDataSource<Section, Product> {
        let cellRegistration = UICollectionView.CellRegistration<CollectionViewListCell, Product> {
            (cell, indexPath, item) in
        }
      
        let dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
            cell.updateAllComponents(from: item)
            
            return cell
        }
        
        return dataSource
    }
    
    func applySnapShot(products: [Product]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products)
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
}

