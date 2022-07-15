import UIKit

class ViewController: UIViewController {
    var segmentControl: UISegmentedControl?
    var collectionView: UICollectionView?
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let avd = ProductsDataManager()
        avd.getData(pageNumber: 1, itemsPerPage: 10) { (result: Products) in
            print(result)
        }
        
        configureHierarchy()
        configureDataSoure()
        configureSegmentControl()
        
        setupCollectionViewLayout()
    }
        
    private func setupCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()

        let width = self.view.frame.width
        let height = self.view.frame.height

        flowLayout.minimumLineSpacing = 2
        flowLayout.estimatedItemSize = CGSize(width: width, height: height * 0.08)

        collectionView?.collectionViewLayout = flowLayout
        collectionView?.backgroundColor = .systemGray
    }
}

extension ViewController {
    private func configureSegmentControl() {
        segmentControl = UISegmentedControl(items: Titles.toString)
        segmentControl?.selectedSegmentIndex = Titles.LIST.rawValue
        segmentControl?.addTarget(self, action: #selector(changeLayout), for: .valueChanged)
        navigationItem.titleView = segmentControl
    }
}

extension ViewController {
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension ViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        collectionView?.backgroundColor = .white
        collectionView?.delegate = self
        
        guard let collectionView = collectionView else { return }
        
        view.addSubview(collectionView)
    }
    
    private func configureDataSoure() {
        let cellRegistration = UICollectionView.CellRegistration<ItemCollectionViewCell, Int> { (cell, indexPath, identifier) in
            cell.backgroundColor = .systemBackground
        }
        
        guard let collectionView = collectionView else { return }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0...94))
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
}

extension ViewController {
    @objc private func changeLayout() {
        if segmentControl?.selectedSegmentIndex == Titles.LIST.rawValue {
            self.collectionView?.setCollectionViewLayout(createListLayout(), animated: true)
            setupCollectionViewLayout()
        } else if segmentControl?.selectedSegmentIndex == Titles.GRID.rawValue {
            self.collectionView?.setCollectionViewLayout(createGridLayout(), animated: true)
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
