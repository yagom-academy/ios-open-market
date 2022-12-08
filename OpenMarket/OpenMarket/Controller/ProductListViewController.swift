//  Created by Aejong, Tottale on 2022/11/22.

import UIKit

enum Section: Hashable {
    
    case main
}

protocol UploadDelegate : AnyObject {
    func isUploaded(_ isLoaded:Bool)
}

final class ProductListViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
    private var productData: ProductList?
    private var segmentItem: SegmentItem = .list {
        didSet {
            switch segmentItem {
            case .list:
                collectionView.collectionViewLayout = createListLayout()
            case .grid:
                collectionView.collectionViewLayout = createGridLayout()
            }
            applySnapshotUsingReloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        configureSegmentedControl()
        configureNavigationBar()
        configureAddButton()
        configureCollectionViewConstraint()
        
        fetchProductList()
    }
    
    func fetchProductList() {
        ProductNetworkManager.shared.fetchProductList() { [weak self] result in
            switch result {
            case .success(let data):
                self?.productData = data
                DispatchQueue.main.async {
                    self?.configureDataSource()
                    self?.applySnapshot()
                }
            default :
                return
            }
        }
    }
    
    @objc private func addButtonPressed() {
        let addProductViewController = AddProductViewController()
        addProductViewController.delegate = self
        addProductViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(addProductViewController, animated: true)
    }
    
    private func configureNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .systemGray6
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func configureAddButton() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                      action: #selector(addButtonPressed))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}

extension ProductListViewController: UploadDelegate {
    func isUploaded(_ isLoaded: Bool) {
        if isLoaded {
            fetchProductList()
            showAlert(title: "업로드 완료", message: "완료")
        } else {
            showAlert(title: "업로드 실패", message: "실패")
        }
    }
}

private extension ProductListViewController {
    
    enum SegmentItem: Int {
        case list = 0
        case grid = 1
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
        guard let segmentItem = SegmentItem.init(rawValue: segcon.selectedSegmentIndex) else {
            return
        }
        self.segmentItem = segmentItem
    }
}

private extension ProductListViewController {
    
    private func configureCollectionViewConstraint() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: createListLayout())
        
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
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
    
    private func configureDataSource() {
        let listCellRegistration = UICollectionView.CellRegistration<ProductListCell, Product> { (cell, indexPath, product) in
            cell.updateConfiguration(with: product)
            cell.accessories = [.disclosureIndicator()]
        }
        
        let gridCellRegistration = UICollectionView.CellRegistration<ProductGridCell, Product> { cell, indexPath, product in
            cell.configureCell(with: product)
        }
        
        self.dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: self.collectionView) { (collectionView, indexPath, product) -> UICollectionViewCell? in
            switch self.segmentItem {
            case .list:
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: product)
            case .grid:
                return collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration, for: indexPath, item: product)
            }
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        if let product = self.productData?.pages {
            snapshot.appendItems(product)
        }
        self.dataSource.apply(snapshot)
    }
    
    private func applySnapshotUsingReloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        if let product = self.productData?.pages {
            snapshot.appendItems(product)
        }
        snapshot.reloadSections([.main])
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
}
