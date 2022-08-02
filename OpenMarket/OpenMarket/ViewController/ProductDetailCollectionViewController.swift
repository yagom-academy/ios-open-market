//
//  ProductDetailCollectionViewController.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/08/02.
//

import UIKit

class ProductDetailCollectionViewController: UICollectionViewController {
    // MARK: Inner types
    enum Section: Int ,Hashable {
        case image
        case info
    }
    
    // MARK: Typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Section, DetailProduct>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, DetailProduct>
    
    // MARK: Properties
    lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createLayout()
        applySnapshots()
    }
    
    // MARK: DataSource
    private func makeDataSource() -> DataSource {
        let infoRegistration = UICollectionView.CellRegistration<DetailInfoCollectionViewCell, DetailProduct>.init { cell, indexPath, item in
            cell.configureCell(with: item)
        }
        
        let imageRegistration = UICollectionView.CellRegistration<DetailImageCollectionViewCell, DetailProduct>.init { cell, indexPath, item in
            cell.imageView.configureImage(url: item.images[indexPath.row], cell, indexPath, self.collectionView)
            cell.imageNumberLabel.text = "\(indexPath.row+1)/\(item.images.count)"
        }
    
        return DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .image:
                return collectionView.dequeueConfiguredReusableCell(using: imageRegistration, for: indexPath, item: item)
            case .info:
                return collectionView.dequeueConfiguredReusableCell(using: infoRegistration, for: indexPath, item: item)
            }
        }
    }
    
    // MARK: Layout
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            let section: NSCollectionLayoutSection
            
            switch sectionKind {
            case .image:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.7))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            case .info:
                let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: layoutSize)
                let groupsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(1.0))
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupsize,
                                                               subitem: item,
                                                               count: 1)
                section = NSCollectionLayoutSection(group: group)
            }
            
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    let sample = [ DetailProduct(productName: "맥북", price: "2000", bargainPrice: "1000", stock: "10", description: "맥북입니다.",
                                 images: ["https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/6/thumb/f9aa6e0d787711ecabfa3f1efeb4842b.jpg", "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/22/thumb/2a78eba479b211ec9173f346cbe040c0.png"]),
                   
                   
                   DetailProduct(productName: "맥북", price: "2000", bargainPrice: "1000", stock: "10", description: "맥북입니다.", images: ["https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/6/thumb/f9aa6e0d787711ecabfa3f1efeb4842b.jpg", "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/22/thumb/2a78eba479b211ec9173f346cbe040c0.png"])]
    
    let sample2 =  DetailProduct(productName: "맥북", price: "2000", bargainPrice: "1000", stock: "10", description: "맥북입니다.", images: ["https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/6/thumb/f9aa6e0d787711ecabfa3f1efeb4842b.jpg", "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/22/thumb/2a78eba479b211ec9173f346cbe040c0.png"])
    
    // MARK: Data & Snapshot
    private func applySnapshots() {
        var itemSnapshot = SnapShot()
        itemSnapshot.appendSections([.image, .info])
     
//        itemSnapshot.appendItems([sample])
        
        itemSnapshot.appendItems(sample, toSection: .image)
        itemSnapshot.appendItems([sample2], toSection: .info)
        
        dataSource.apply(itemSnapshot, animatingDifferences: false)

//        var imageSnapshot = NSDiffableDataSourceSectionSnapshot<DetailProduct>()
//        imageSnapshot.append([sample])
//        dataSource.apply(imageSnapshot, to: .image, animatingDifferences: false)
//
//        var infoSnapshot = NSDiffableDataSourceSectionSnapshot<DetailProduct>()
//        infoSnapshot.append([sample])
//        dataSource.apply(infoSnapshot, to: .info, animatingDifferences: false)
        
        
//        let recentItems = [sample]
//        var recentsSnapshot = NSDiffableDataSourceSectionSnapshot<DetailProduct>()
//        recentsSnapshot.append(recentItems)
//        dataSource.apply(recentsSnapshot, to: .image, animatingDifferences: false)
//
//        let infoItems = [sample]
//        var infoSnapshot = NSDiffableDataSourceSectionSnapshot<DetailProduct>()
//        infoSnapshot.append(infoItems)
//        dataSource.apply(infoSnapshot, to: .info, animatingDifferences: false)
    }
}

struct DetailProduct: Hashable {
    let productName: String
    let price: String
    let bargainPrice: String
    let stock: String
    let description: String
    let images: [String]
    
    private let identifier = UUID()
}
