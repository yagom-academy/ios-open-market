//
//  ManagingViewModel.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/25.
//

import UIKit

class ManagingViewModel {
    enum Section: CaseIterable {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ImageInfo>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ImageInfo>
    
    var datasource: DataSource?
    
    let productsAPIServie = APIProvider<Products>()
    var images: [ImageInfo] = []
    
    weak var delegate: ManagingAlertDelegate?
    
    func generateUUID() -> String {
        return UUID().uuidString + ".jpg"
    }
    
    func applySnapshot() {
        DispatchQueue.main.async {
            var snapshot = Snapshot()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(self.images, toSection: .main)
            self.datasource?.apply(snapshot)
        }
    }
}
