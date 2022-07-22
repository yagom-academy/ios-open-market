//
//  ListCollectionView.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/19.
//

import UIKit

final class ListCollectionView: UICollectionView {
    // MARK: - properties
    
    private var listViewDataSource: UICollectionViewDiffableDataSource<Section, ProductDetail>? = nil
    private let listViewCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ProductDetail> {
        (cell, indexPath, item) in
        var content = cell.defaultContentConfiguration()
        content.text = item.name
        content.image = item.makeThumbnailImage()
        content.imageProperties.maximumSize = CGSize(width: ImageSize.width, height: ImageSize.height)
        content.secondaryAttributedText = item.makePriceText()
        
        let accessory = UICellAccessory.disclosureIndicator()
        var stockAccessory = UICellAccessory.disclosureIndicator()
        
        if item.stock == .zero {
            let text = PriceText.soldOut.text
            stockAccessory = UICellAccessory.label(
                text: text,
                options: .init(tintColor: .systemOrange,
                               font: .preferredFont(forTextStyle: .footnote)))
        } else {
            let text = "\(PriceText.stock.text)\(item.stock)"
            stockAccessory = UICellAccessory.label(
                text: text,
                options: .init(tintColor: .systemGray,
                               font: .preferredFont(forTextStyle: .footnote))
            )
        }
        
        cell.accessories = [stockAccessory, accessory]
        cell.contentConfiguration = content
    }
    
    // MARK: - initializers
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setUpDataSource()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setUpDataSource()
    }
    
    // MARK: - functions
    
    private func setUpDataSource() {
        listViewDataSource = UICollectionViewDiffableDataSource<Section, ProductDetail>(collectionView: self) { [weak self]
            (collectionView: UICollectionView,
             indexPath: IndexPath,
             identifier: ProductDetail) -> UICollectionViewCell? in
            
            guard let listViewCellRegistration = self?.listViewCellRegistration
            else { return UICollectionViewCell() }
            
            return collectionView.dequeueConfiguredReusableCell(using: listViewCellRegistration,
                                                                for: indexPath,
                                                                item: identifier)
        }
    }
    
    func setSnapshot(productsList: [ProductDetail]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductDetail>()
        snapshot.appendSections([.list])
        snapshot.appendItems(productsList)
        
        listViewDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func deleteSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductDetail>()
        snapshot.deleteAllItems()
        
        listViewDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - image size
    
    private enum ImageSize {
        static let width = 70
        static let height = 70
    }
}

