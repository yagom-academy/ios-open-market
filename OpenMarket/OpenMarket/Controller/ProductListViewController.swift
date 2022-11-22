//
//  OpenMarket - ProductListViewController.swift
//  Created by Aejong, Tottale on 2022/11/22.
// 

import UIKit

private enum Section: Hashable {
    case main
}

class ProductListViewController: UIViewController {
    
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
        networkProvider.fetchProductList(query: nil) { result in
            switch result {
            case .success(let data):
                self.productData = data
                DispatchQueue.main.async {
                    self.configureHierarchy()
                    self.configureDataSource()
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
        let segmentTextContent = [NSLocalizedString("LIST", comment: ""), NSLocalizedString("GRID", comment: "")]
        let segmentedControl = UISegmentedControl(items: segmentTextContent)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBackground
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .normal)
        
        self.navigationItem.titleView = segmentedControl
    }
    
    private func configureAddButton() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        self.navigationItem.rightBarButtonItem = addItem
    }
}

fileprivate extension UIConfigurationStateCustomKey {
    static let product = UIConfigurationStateCustomKey("product")
}

extension ProductListViewController {
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension ProductListViewController {
    private func configureHierarchy() {
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

private extension UICellConfigurationState {
    var productData: Product? {
        set { self[.product] = newValue }
        get { return self[.product] as? Product }
    }
}

class ProductListCell: UICollectionViewListCell {
    private var productData: Product?
    
    private let productTypeLabel = UILabel()
    private var productTypeConstraints: (leading: NSLayoutConstraint, trailing: NSLayoutConstraint)?
    
    func update(with newProduct: Product) {
        guard productData != newProduct else { return }
        productData = newProduct
        setNeedsUpdateConfiguration()
    }
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.productData = self.productData
        return state
    }
    
    private func defaultProductConfiguration() -> UIListContentConfiguration {
        return .subtitleCell()
    }
    
    private lazy var productListContentView = UIListContentView(configuration: defaultProductConfiguration())
}

extension ProductListCell {
    func setupViewsIfNeeded() {
        guard productTypeConstraints == nil else {
            return
        }
        
        [productListContentView, productTypeLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        productTypeLabel.font = .preferredFont(forTextStyle: .footnote)
        productTypeLabel.textColor = .gray
        
        let constraints = (leading:
                            productTypeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: productListContentView.trailingAnchor),
                           trailing:
                            productTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor) )
        
        NSLayoutConstraint.activate([
            productListContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productListContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            productListContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productTypeLabel.topAnchor.constraint(equalTo: productListContentView.topAnchor),
            constraints.leading,
            constraints.trailing
        ])
        
        productTypeConstraints = constraints
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()
        
        var content = defaultProductConfiguration().updated(for: state)
        
        content.image = urlToImage(state.productData?.thumbnail ?? "")
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        content.text = state.productData?.name
        content.textProperties.font = .preferredFont(forTextStyle: .body)
        content.secondaryText = "\(productData?.currency.description ?? "") \(productData?.price.description ?? "")"
        
        productListContentView.configuration = content
        
        productTypeLabel.text = "잔여수량: \(state.productData?.stock ?? 0)"
    }
    
    func urlToImage(_ urlString: String) -> UIImage? {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
}

