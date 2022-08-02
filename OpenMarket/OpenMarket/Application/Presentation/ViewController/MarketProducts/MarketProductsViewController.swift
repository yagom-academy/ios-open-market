//
//  OpenMarket - MarketProductsViewController.swift
//  Created by 데릭, 수꿍.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class MarketProductsViewController: UIViewController {
    // MARK: Properties
    
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
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        configureListCollectionView()
        configureGridCollectionView()
        
        configureListDataSource()
        configureGridDataSource()
        
        marketProductsViewModel = MarketProductsViewModel()
        connectDelegate()
        
        gridCollectionView?.isHidden = true
        
        setUpNavigationItems()
        fetchData()
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
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        self.navigationItem.titleView = self.segmentedControl
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(title: "+",
                                                                  style: .plain,
                                                                  target: self,
                                                                  action: #selector(addButtonTapped(_:)))
        self.segmentedControl.addTarget(self,
                                        action: #selector(didSegmentedControlTapped(_:)),
                                        for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
    }
    
    private func fetchData() {
        productListAPIManager?.requestAndDecodeProduct(dataType: ProductList.self) { [weak self] result in
            switch result {
            case .success(let productList):
                self?.marketProductsViewModel?.format(data: productList)
                
            case .failure(let error):
                guard let message = error.errorDescription else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.presentConfirmAlert(message: message)
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
        
        self.present(productEnrollmentViewController, animated: true)
    }
}

// MARK: - MarketProductsViewDelegate

extension MarketProductsViewController: MarketProductsViewControllerDelegate {
    func didReceiveResponse(_ view: MarketProductsViewController.Type,
                            by data: ProductListEntity) {
        updateUI(by: data)
    }
}

// MARK: - UICollectionViewDelegate

extension MarketProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = shouldHideListView ? self.listDataSource?.itemIdentifier(for: indexPath) : self.gridDataSource?.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        let productDetailViewController = ProductDetailViewController()
        productDetailViewController.productID = product.id
        productDetailViewController.title = product.name
        self.navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}
