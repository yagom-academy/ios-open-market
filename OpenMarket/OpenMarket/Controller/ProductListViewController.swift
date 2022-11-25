//  Created by Aejong, Tottale on 2022/11/22.

import UIKit

enum Section: Hashable {
    
    case main
}

final class ProductListViewController: UIViewController {
    
    var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
    var productData: ProductList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureSegmentedControl()
        configureNavigationBar()
        configureAddButton()
        
        let networkProvider = NetworkAPIProvider()
        
        networkProvider.fetchProductList(query: [.itemsPerPage: "200"]) { [weak self] result in
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

extension ProductListViewController {
    
    private func configureNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .systemGray6
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func configureSegmentedControl() {
        let segmentTextContent = [NSLocalizedString("LIST", comment: ""),
                                  NSLocalizedString("GRID", comment: "")]
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
    
    @objc func segControlChanged(segcon: UISegmentedControl) {
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

extension ProductListViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension ProductListViewController {
    
    private func configureHierarchy() {
        if let collectionView {
            collectionView.removeFromSuperview()
        }
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductListCell, Product> { (cell, indexPath, product) in
            cell.update(with: product)
            cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) { (collectionView, indexPath, product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(productData?.pages ?? [])
        dataSource.apply(snapshot)
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
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createGridLayout())
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureGridDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductGridCell, Product> { cell, indexPath, product in
            cell.configureCell(with: product)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapShot.appendSections([.main])
        snapShot.appendItems(productData?.pages ?? [])
        dataSource.apply(snapShot)
    }
}
