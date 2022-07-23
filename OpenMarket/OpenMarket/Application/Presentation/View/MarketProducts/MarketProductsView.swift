//
//  MarketProductsView.swift
//  OpenMarket
//
//  Created by Kay on 2022/07/21.
//


import UIKit

final class MarketProductsView: UIView {
    fileprivate enum Section {
        case main
    }
    
    private var productsModel: [ProductEntity] = []
    
    private var listCollectionView: UICollectionView?
    private var listDataSource: UICollectionViewDiffableDataSource<Section, ProductEntity>?
    
    private var gridCollectionView: UICollectionView?
    private var gridDataSource: UICollectionViewDiffableDataSource<Section, ProductEntity>?
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [
            SegmentedControlItem.list.name,
            SegmentedControlItem.grid.name])
        control.translatesAutoresizingMaskIntoConstraints = false
        
        return control
    }()
    
    private var shouldHideListView: Bool = true {
        didSet {
            self.listCollectionView?.isHidden = shouldHideListView
            self.gridCollectionView?.isHidden = !shouldHideListView
        }
    }
    
    init(_ rootViewController: UIViewController) {
        super.init(frame: .null)
        
        rootViewController.view.backgroundColor = .white
        setNavigationItems(of: rootViewController)
        fetchData(from: rootViewController)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MarketProductsView {
    func setNavigationItems(of rootViewController: UIViewController) {
        rootViewController.navigationItem.titleView = self.segmentedControl
        rootViewController.navigationItem.rightBarButtonItem  = UIBarButtonItem(title: "+",
                                                                  style: .plain,
                                                                  target: rootViewController,
                                                                  action: #selector(addTapped))
        self.segmentedControl.addTarget(self,
                                        action: #selector(didSegmentedControlTapped(_:)),
                                        for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc func didSegmentedControlTapped(_ segment: UISegmentedControl) {
        self.shouldHideListView = segment.selectedSegmentIndex != 0
    }
    
    @objc func addTapped() {
        
    }
    
    func fetchData(from rootViewController: UIViewController) {
        let url = "https://market-training.yagom-academy.kr/api/products?page_no=1&items_per_page=50"
        
        let openMarket = NetworkProvider(session: URLSession.shared)
        openMarket.requestAndDecode(url: url,
                                    dataType: ProductList.self) { result in
            switch result {
            case .success(let productList):
                productList.pages.forEach { product in
                    guard let thumbnailImage = product.thumbnailImage else {
                        return
                    }
                    
                    let item = ProductEntity(thumbnailImage: thumbnailImage,
                                             name: product.name,
                                             currency: product.currency,
                                             originalPrice: product.price,
                                             discountedPrice: product.bargainPrice,
                                             stock: product.stock)
                    
                    self.productsModel.append(item)
                }
                
                DispatchQueue.main.async {
                    self.createGridCollectionView(of: rootViewController.view)
                    self.configureGridDataSource()
                    self.gridCollectionView.isHidden = true
                    self.createListCollectionView(of: rootViewController.view)
                    self.configureListDataSource()
                }
                
            case .failure(let error):
                guard let message = error.errorDescription else {
                    return
                }
                
                rootViewController.presentConfirmAlert(message: message)
            }
        }
    }
}

private extension MarketProductsView {
    func createListCollectionView(of rootView: UIView) {
        listCollectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: configureListLayout())
        
        guard let collectionView = listCollectionView else {
            return
        }
        
        rootView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor),
        ])
    }
    
    func createListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func configureListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCollectionCell, ProductEntity> { (cell, indexPath, item) in
            cell.updateUI(item)
            cell.accessories = [.disclosureIndicator()]
        }
        
        guard let collectionView = listCollectionView else {
            return
        }
        
        listDataSource = UICollectionViewDiffableDataSource<Section, ProductEntity>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: ProductEntity) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: identifier)
        }
        
        if let dataSource = listDataSource {
            applySnapShot(to: dataSource)
        }
    }
    
    func createGridCollectionView(of rootView: UIView) {
        gridCollectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createGridLayout(of: rootView))
        
        guard let collectionView = gridCollectionView else {
            return
        }
        
        rootView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor),
        ])
    }
    
    func createGridLayout(of rootView: UIView) -> UICollectionViewCompositionalLayout{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(rootView.frame.height * 0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 2)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(10)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 10,
                                                        bottom: 0,
                                                        trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func configureGridDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<GridCollectionCell, ProductEntity> { cell, indexPath, item in
            cell.layer.borderColor = UIColor.systemGray.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 10
            
            cell.updateUI(item)
        }
        
        guard let collectionView = gridCollectionView else {
            return
        }
        
        gridDataSource = UICollectionViewDiffableDataSource<Section, ProductEntity>(collectionView: collectionView) { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
        
        if let dataSource = gridDataSource {
            applySnapShot(to: dataSource)
        }
    }
    
    func applySnapShot(to dataSource: UICollectionViewDiffableDataSource<Section, ProductEntity>) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, ProductEntity>()
        snapShot.appendSections([.main])
        snapShot.appendItems(productsModel)
        
        dataSource.apply(snapShot,
                         animatingDifferences: true)
    }
}
