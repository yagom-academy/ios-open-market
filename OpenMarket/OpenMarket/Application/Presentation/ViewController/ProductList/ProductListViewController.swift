//
//  OpenMarket - ProductListViewController.swift
//  Created by 데릭, 수꿍.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class ProductListViewController: UIViewController {
    // MARK: Properties
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, ProductEntity>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ProductEntity>
    
    private let networkProvider = APIClient()
    private var marketProductsViewModel: ProductListViewModel?
    private var productListAPIManager: ProductListAPIManager?
    
    private var listCollectionView: UICollectionView?
    private var listDataSource: DataSource?
    
    private var gridCollectionView: UICollectionView?
    private var gridDataSource: DataSource?
    
    private var listSnapshot = Snapshot()
    private var gridSnapshot = Snapshot()
    
    private var pageNumber: Int = 1
    
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
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delayUIForFetchingData()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        configureListCollectionView()
        configureGridCollectionView()
        configureListDataSource()
        configureGridDataSource()
        
        marketProductsViewModel = ProductListViewModel()
        connectDelegate()
        
        gridCollectionView?.isHidden = true
        
        setUpNavigationItems()
        configureRefreshControl()
    }
    
    private func delayUIForFetchingData() {
        LoadingIndicator.showLoading()
        resetData()
        setUpCollectionViewFor(hiding: true)
    }
    
    private func configureListCollectionView() {
        listCollectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: configureListLayout())
        
        guard let collectionView = listCollectionView else {
            return
        }
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureGridCollectionView() {
        gridCollectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: configureGridLayout())
        guard let collectionView = gridCollectionView else {
            return
        }
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
    
    private func configureGridLayout() -> UICollectionViewCompositionalLayout{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(view.frame.height * 0.3))
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
    
    private func setUpNavigationItems() {
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem  = UIBarButtonItem(title: "+",
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(addButtonTapped(_:)))
        segmentedControl.addTarget(self,
                                   action: #selector(didSegmentedControlTapped(_:)),
                                   for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    private func setUpCollectionViewFor(hiding: Bool) {
        if segmentedControl.selectedSegmentIndex == 0 {
            listCollectionView?.isHidden = hiding
            listCollectionView?.refreshControl?.stop()
        } else {
            gridCollectionView?.isHidden = hiding
            gridCollectionView?.refreshControl?.stop()
        }
    }
    
    private func fetchData() {
        productListAPIManager = ProductListAPIManager(pageNumber: pageNumber)
        productListAPIManager?.requestAndDecodeProduct(dataType: ProductList.self) { [weak self] result in
            switch result {
            case .success(let productList):
                self?.marketProductsViewModel?.format(data: productList)
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.presentConfirmAlert(message: error.errorDescription)
                }
            }
        }
    }
    
    private func applySnapshot(by data: ProductListEntity) {
        listSnapshot.appendItems(data.productEntity)
        listDataSource?.apply(listSnapshot,
                              animatingDifferences: false)
        
        gridSnapshot.appendItems(data.productEntity)
        gridDataSource?.apply(gridSnapshot,
                              animatingDifferences: false)
    }
    
    private func makeSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        
        return snapshot
    }
    
    private func configureRefreshControl() {
        listCollectionView?.refreshControl = UIRefreshControl()
        listCollectionView?.refreshControl?.addTarget(self,
                                                      action:#selector(listHandleRefreshControl),
                                                      for: .valueChanged)
        
        gridCollectionView?.refreshControl = UIRefreshControl()
        gridCollectionView?.refreshControl?.addTarget(self,
                                                      action:#selector(gridHandleRefreshControl),
                                                      for: .valueChanged)
    }
    
    private func updateUI(by data: ProductListEntity) {
        applySnapshot(by: data)
    }
    
    private func resetData() {
        pageNumber = 1
        
        listSnapshot = makeSnapshot()
        gridSnapshot = makeSnapshot()
    
        fetchData()
    }
    
    // MARK: - Action
    
    @objc private func listHandleRefreshControl() {
        resetData()
    }
    
    @objc private func gridHandleRefreshControl() {
        resetData()
    }
    
    @objc private func didSegmentedControlTapped(_ segment: UISegmentedControl) {
        self.shouldHideListView = segment.selectedSegmentIndex != 0
    }
    
    @objc private func addButtonTapped(_ sender: UIBarButtonItem) {
        let productEnrollmentViewController = ProductEnrollmentViewController()
        
        DispatchQueue.main.async { [weak self] in
            self?.present(viewController: productEnrollmentViewController)
        }
    }
}

// MARK: - MarketProductsViewDelegate

extension ProductListViewController: ProductListDelegate {
    func productListViewController(_ view: ProductListViewController.Type,
                                   didRecieve productListInfo: ProductListEntity) {
        DispatchQueue.main.async { [weak self] in
            self?.setUpCollectionViewFor(hiding: false)
            LoadingIndicator.hideLoading()
            self?.updateUI(by: productListInfo)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = shouldHideListView
                ? listDataSource?.itemIdentifier(for: indexPath)
                : gridDataSource?.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath,
                                        animated: true)
            return
        }
        
        let productDetailViewController = ProductDetailsViewController()
        productDetailViewController.productID = product.id
        productDetailViewController.productVendorID = product.vendorID
        productDetailViewController.title = product.name
        
        navigationController?.pushViewController(productDetailViewController,
                                                 animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let listCollectionView = listCollectionView,
              let gridCollectionView = gridCollectionView else {
            return
        }
        
        let _ = segmentedControl.selectedSegmentIndex == 0
        ? reloadDataDidScrollDown(listCollectionView)
        : reloadDataDidScrollDown(gridCollectionView)
    }
    
    private func reloadDataDidScrollDown(_ collectionView: UICollectionView) {
        let trigger = collectionView.contentSize.height - collectionView.bounds.size.height
        
        if collectionView.contentOffset.y > trigger {
            DispatchQueue.main.async { [weak self] in
                self?.pageNumber += 1
                self?.fetchData()
                collectionView.reloadData()
            }
        }
    }
}
