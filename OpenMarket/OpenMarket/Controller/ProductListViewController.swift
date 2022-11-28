//  Created by Aejong, Tottale on 2022/11/22.

import UIKit

enum Section: Hashable {
    
    case main
}

final class ProductListViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
    private var productData: ProductList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        configureSegmentedControl()
        configureNavigationBar()
        configureAddButton()
            
        ProductNetworkManager.shared.fetchProductList() { [weak self] result in
            switch result {
            case .success(let data):
                self?.productData = data
                DispatchQueue.main.async {
                    self?.configureHierarchy()
                    self?.configureDataSource()
                }
            default :
                return
            }
        }
    }
    
    @objc private func addButtonPressed() {
        let addProductViewController = AddProductViewController()
        self.present(addProductViewController, animated: true, completion: nil)
    }
}

private extension ProductListViewController {
    
    private func configureNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .systemGray6
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func configureSegmentedControl() {
        let segmentTextContent = ["LIST", "GRID"]
        let segmentedControl = UISegmentedControl(items: segmentTextContent)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBackground
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white],
                                                for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue],
                                                for: .normal)
        segmentedControl.addTarget(self, action: #selector(segControlChanged),
                                   for: UIControl.Event.valueChanged)
        self.navigationItem.titleView = segmentedControl
    }
    
    @objc private func segControlChanged(segcon: UISegmentedControl) {
        switch segcon.selectedSegmentIndex {
        case 0:
            self.configureHierarchy()
            self.configureDataSource()
        case 1:
            self.createGridCollectionView()
            self.configureGridDataSource()
        default: return
        }
    }
    
    private func configureAddButton() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                      action: #selector(addButtonPressed))
        self.navigationItem.rightBarButtonItem = addItem
    }
}

private extension ProductListViewController {
    
    private func createListLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureListHierarchy() {
        if let collectionView {
            collectionView.removeFromSuperview()
        }
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(self.collectionView)
    }
    
    private func configureListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductListCell, Product> { (cell, indexPath, product) in
            cell.update(with: product)
            cell.accessories = [.disclosureIndicator()]
        }
        
        self.dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: self.collectionView) { (collectionView, indexPath, product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.productData?.pages ?? [])
        self.dataSource.apply(snapshot)
    }
}

extension ProductListViewController {
    
    private func createGridLayout() -> UICollectionViewCompositionalLayout{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(self.view.frame.height * 0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(10)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func createGridCollectionView() {
        if let collectionView {
            collectionView.removeFromSuperview()
        }
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: createGridLayout())
        
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureGridDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductGridCell, Product> { cell, indexPath, product in
            cell.configureCell(with: product)
        }
        
        self.dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapShot.appendSections([.main])
        snapShot.appendItems(self.productData?.pages ?? [])
        self.dataSource.apply(snapShot)
    }
}
