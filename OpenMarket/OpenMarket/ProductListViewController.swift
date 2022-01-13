import UIKit

class ProductListViewController: UIViewController {
    enum Section: Hashable {
        case main
    }
    
    lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeGridLayout())
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    let data = [1,2,3,4,5,5]
    
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
        configureDataSource()
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CollectionViewGridCell, Int> {
            (cell, indexPath, item) in
        }
      
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<20))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
    

