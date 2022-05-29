//
//  ManagingViewModel.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/25.
//

import UIKit

class ManagingViewModel {
    enum Constants {
        static let dotJPG = ".jpg"
        static let plus = "plus"
        static let jpg = "jpg"
        static let png = "png"
    }
    
    enum Section: CaseIterable {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ImageInfo>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ImageInfo>
    
    var datasource: DataSource?
    
    let productsAPIServie = APIProvider()
    var images: [ImageInfo] = []
    
    weak var delegate: ManagingAlertDelegate?
    
    func generateUUID() -> String {
        return UUID().uuidString + Constants.dotJPG
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
