//
//  OpenMarket - OpenMarketViewController.swift
//  Created by groot, bard. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    enum Section {
        case list
    }
    
    enum GridSection {
        case grid
    }
    
    var loadingView : UIView?
    var productsList = [ProductDetail]()
    var listViewDataSource: UICollectionViewDiffableDataSource<Section, ProductDetail>? = nil
    var gridViewDataSource: UICollectionViewDiffableDataSource<GridSection, ProductDetail>? = nil
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["List", "Grid"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    var listView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let listView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        listView.translatesAutoresizingMaskIntoConstraints = false
        return listView
    }()
    
    lazy var gridView: UICollectionView = {
        let layout = self.createLayout()
        let gridView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        
        return gridView
    }()
    
    func createLayout() -> UICollectionViewCompositionalLayout{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(self.view.frame.height * 0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: 2)
        group.interItemSpacing = .fixed(20)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(10)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5,
                                                        leading: 5,
                                                        bottom: 5,
                                                        trailing: 5)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    let listViewCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,
                                                                     ProductDetail>
    { (cell, indexPath, item) in
        guard let url = URL(string: item.thumbnail) else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        
        var content = cell.defaultContentConfiguration()
        content.text = item.name
        let first = "\(item.currency.rawValue) \(item.price.formatNumber())"
        let second = "\n\(item.currency.rawValue) \(item.bargainPrice.formatNumber())"
        
        content.secondaryAttributedText = NSMutableAttributedString()
            .bold(string: first)
            .regular(string: second)
        content.image = UIImage(data: data)
        content.imageProperties.maximumSize = CGSize(width: 70, height: 70)
        
        let accessory = UICellAccessory.disclosureIndicator()
        var stockAccessory = UICellAccessory.disclosureIndicator()
        
        if item.stock == 0 {
            let text = "품절"
            stockAccessory = UICellAccessory.label(
                text: text,
                options: .init(tintColor: .systemOrange,
                               font: .preferredFont(forTextStyle: .footnote))
            )
        } else {
            let text = "잔여수량 : \(item.stock)"
            stockAccessory = UICellAccessory.label(
                text: text,
                options: .init(tintColor: .systemGray,
                               font: .preferredFont(forTextStyle: .footnote))
            )
        }
        cell.accessories = [stockAccessory, accessory]
        cell.contentConfiguration = content
    }
    
    let gridViewCellRegistration = UICollectionView.CellRegistration<GridCollectionViewCell,
                                                                     ProductDetail>
    { (cell, indexPath, item) in
        guard let url = URL(string: item.thumbnail) else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        
        cell.productImage.image = UIImage(data: data)
        cell.productName.text = item.name
        
        let first = "\(item.currency.rawValue) \(item.price.formatNumber())"
        let second = "\n\(item.currency.rawValue) \(item.bargainPrice.formatNumber())"
        cell.price.attributedText = NSMutableAttributedString()
            .bold(string: first)
            .regular(string: second)
        
        var text = ""
        
        if item.stock == 0 {
            text = "품절"
            cell.stock.textColor = .systemOrange
        } else {
            text = "잔여수량 : \(item.stock)"
            cell.stock.textColor = .systemGray
        }
        
        cell.stock.text = text
        cell.stock.font = .preferredFont(forTextStyle: .footnote)
    }
    
    var shouldHideListView: Bool? {
        didSet {
            guard let shouldHideListView = self.shouldHideListView else { return }
            self.listView.isHidden = shouldHideListView
            self.gridView.isHidden = !self.listView.isHidden
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSpinner(onView: self.view)
        self.view.backgroundColor = .systemBackground
        self.fetchData()
        self.setSubviews()
        self.setNavigationController()
        self.setSegmentedControl()
        self.configureDataSource()
    }
    
    @objc func segmentButtonDidTap(sender: UISegmentedControl) {
        self.shouldHideListView = (sender.selectedSegmentIndex != 0)
    }
    
    @objc func productRegistrationButtonDidTap() {
        print("productRegistrationButtonDidTapped")
    }
    
    private func fetchData() {
        let productsRequest = ProductsRequest()
        let myURLSession = MyURLSession()
        myURLSession.dataTask(with: productsRequest)
        {
            (result: Result<ProductsDetailList, Error>) in
            switch result {
            case .success(let success):
                for number in 0...29 {
                    self.productsList.append(success.pages[number])
                }
                if self.productsList.count == 30 {
                    self.configurationSnapshot()
                    self.configurationGridSnapshot()
                }
                self.removeSpinner()
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    private func configureDataSource() {
        listViewDataSource = UICollectionViewDiffableDataSource<Section,
                                                                ProductDetail>(collectionView: listView)
        {
            (collectionView: UICollectionView,
             indexPath: IndexPath,
             identifier: ProductDetail) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: self.listViewCellRegistration,
                                                                for: indexPath, item: identifier)
        }
        
        gridViewDataSource = UICollectionViewDiffableDataSource<GridSection,
                                                                ProductDetail>(collectionView: gridView)
        {
            (collectionView: UICollectionView,
             indexPath: IndexPath,
             identifier: ProductDetail) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: self.gridViewCellRegistration,
                                                                for: indexPath, item: identifier)
        }
    }
    
    private func configurationSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductDetail>()
        snapshot.appendSections([.list])
        snapshot.appendItems(productsList)
        listViewDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func configurationGridSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<GridSection, ProductDetail>()
        snapshot.appendSections([.grid])
        snapshot.appendItems(productsList)
        gridViewDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
