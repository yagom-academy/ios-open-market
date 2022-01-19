import UIKit

class GridCollectionViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCollectionView()
        configureLayout()
    }
    
    private func createCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createdGridLayout())
        dataSource = createdGridDataSource()
    }
}

//MARK: - Layout
extension GridCollectionViewController {
    private func configureLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func createdGridLayout() -> UICollectionViewLayout {
        let spacing: Double = 10
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(230)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: itemSize.heightDimension
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets.leading = spacing/2
        section.contentInsets.trailing = spacing/2
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

//MARK: - CollectionView Data Source
extension GridCollectionViewController {
    typealias Product = NetworkingAPI.ProductListQuery.Response.Page

    private enum Section: Hashable {
        case main
    }
    
    private func createdGridDataSource() -> UICollectionViewDiffableDataSource<Section, Product> {
        let cellRegistration = UICollectionView.CellRegistration<CollectionViewGridCell, Product> {
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
        guard products.isEmpty == false else {
            return
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products)
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
}
