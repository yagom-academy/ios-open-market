//
//  MarketProductsView.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//


import UIKit

final class MarketProductsView: UIView {
    // MARK: Properties
    
    fileprivate enum Section {
        case main
    }
    
    private let networkProvider = APIClient()
    private var marketProductsViewModel: MarketProductsViewModel?
    private let productListAPIManager = ProductListAPIManager()
    
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
    
    private var rootViewController: UIViewController?
    
    init(_ rootViewController: UIViewController) {
        super.init(frame: .null)
        
        self.rootViewController = rootViewController
        rootViewController.view.backgroundColor = .white
        configureUI(from: rootViewController)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI
    
    private func configureUI(from rootViewController: UIViewController) {
        configureListCollectionView(of: rootViewController.view)
        configureGridCollectionView(of: rootViewController.view)
        
        configureListDataSource()
        configureGridDataSource()
        
        marketProductsViewModel = MarketProductsViewModel()
        connectDelegate()
        
        gridCollectionView?.isHidden = true
        
        setUpNavigationItems(of: rootViewController)
        fetchData(from: rootViewController)
    }
    
    private func configureListCollectionView(of rootView: UIView) {
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
    
    private func configureGridCollectionView(of rootView: UIView) {
        gridCollectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: configureGridLayout(of: rootView))
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
    
    private func configureListDataSource() {
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
    }
    
    private func configureGridDataSource() {
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
    }
    
    private func connectDelegate() {
        marketProductsViewModel?.delegate = self
        listCollectionView?.delegate = self
        gridCollectionView?.delegate = self
    }
    
    private func configureListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5,
                                                     leading: 5,
                                                     bottom: 5,
                                                     trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureGridLayout(of rootView: UIView) -> UICollectionViewCompositionalLayout{
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
    
    private func setUpNavigationItems(of rootViewController: UIViewController) {
        rootViewController.navigationItem.titleView = self.segmentedControl
        rootViewController.navigationItem.rightBarButtonItem  = UIBarButtonItem(title: "+",
                                                                                style: .plain,
                                                                                target: self,
                                                                                action: #selector(addButtonTapped(_:)))
        self.segmentedControl.addTarget(self,
                                        action: #selector(didSegmentedControlTapped(_:)),
                                        for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
    }
    
    private func fetchData(from rootViewController: UIViewController) {
        productListAPIManager?.retrieveProduct(dataType: ProductList.self) { [weak self] result in
            switch result {
            case .success(let productList):
                self?.marketProductsViewModel?.format(data: productList)
                
            case .failure(let error):
                guard let message = error.errorDescription else {
                    return
                }
                
                DispatchQueue.main.async {
                    rootViewController.presentConfirmAlert(message: message)
                }
            }
        }
    }
    
    private func applySnapShot(to dataSource: UICollectionViewDiffableDataSource<Section, ProductEntity>,
                               by data: ProductListEntity) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, ProductEntity>()
        snapShot.appendSections([.main])
        snapShot.appendItems(data.productEntity)
        
        dataSource.apply(snapShot,
                         animatingDifferences: true,
                         completion: nil)
    }
    
    private func updateUI(by data: ProductListEntity) {
        DispatchQueue.main.async { [weak self] in
            if let listDataSource = self?.listDataSource,
               let gridDataSource = self?.gridDataSource {
                self?.applySnapShot(to: listDataSource, by: data)
                self?.applySnapShot(to: gridDataSource, by: data)
            }
        }
    }
    
    // MARK: - Action
    
    @objc private func didSegmentedControlTapped(_ segment: UISegmentedControl) {
        self.shouldHideListView = segment.selectedSegmentIndex != 0
    }
    
    @objc private func addButtonTapped(_ sender: UIBarButtonItem) {
        let productEnrollmentViewController = UINavigationController(rootViewController: ProductEnrollmentViewController())
        productEnrollmentViewController.modalPresentationStyle = .fullScreen
        rootViewController?.present(to: productEnrollmentViewController)
    }
}

// MARK: - MarketProductsViewDelegate

extension MarketProductsView: MarketProductsViewDelegate {
    func didReceiveResponse(_ view: MarketProductsView.Type,
                            by data: ProductListEntity) {
        updateUI(by: data)
    }
}

// MARK: - UICollectionViewDelegate

extension MarketProductsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let productID = shouldHideListView ? self.listDataSource?.itemIdentifier(for: indexPath)?.id : self.gridDataSource?.itemIdentifier(for: indexPath)?.id else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        let productDetailViewController = ProductDetailViewController()
        productDetailViewController.productID = productID
        rootViewController?.navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}
