//
//  ListCollectionView.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/19.
//

import UIKit

class ListCollectionView: UICollectionView {
    var listViewDataSource: UICollectionViewDiffableDataSource<Section, ProductDetail>? = nil
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let listViewCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ProductDetail> {
        (cell, indexPath, item) in
        var content = cell.defaultContentConfiguration()
        content.text = item.name
        content.image = item.setThumbnailImage()
        content.imageProperties.maximumSize = CGSize(width: 70, height: 70)
        content.secondaryAttributedText = item.setPriceText()
        
        let accessory = UICellAccessory.disclosureIndicator()
        var stockAccessory = UICellAccessory.disclosureIndicator()
        
        if item.stock == 0 {
            let text = "품절"
            stockAccessory = UICellAccessory.label(
                text: text,
                options: .init(tintColor: .systemOrange,
                               font: .preferredFont(forTextStyle: .footnote)))
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
    
    private func configureDataSource() {
        listViewDataSource = UICollectionViewDiffableDataSource<Section, ProductDetail>(collectionView: self) {
            (collectionView: UICollectionView,
             indexPath: IndexPath,
             identifier: ProductDetail) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: self.listViewCellRegistration,
                                                                for: indexPath,
                                                                item: identifier)
        }
    }
    
    func configureSnapshot(productsList: [ProductDetail]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductDetail>()
        snapshot.appendSections([.list])
        snapshot.appendItems(productsList)
        
        listViewDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
