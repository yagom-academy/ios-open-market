//
//  ProductView.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/16.
//

import UIKit

private enum LayoutType: Int {
    case list = 0
    case grid
    
    func layout() -> NSCollectionLayoutSection {
        switch self {
        case .list:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            return section
        case .grid:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(270))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            return section
        }
    }
}

final class ProductView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
        segmentedControl.addTarget(self, action: #selector(switchSegment(segmentedControl:)), for: .valueChanged)
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var layouts: UICollectionViewCompositionalLayout = {
        return UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            return LayoutType.layout(.list)()
        }, configuration: .init())
    }()
    
    private lazy var layoutType: LayoutType = .list {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
       
        return segmentedControl
    }()
    
    lazy var plusButton: UIBarButtonItem = {
        let plusButton = UIBarButtonItem()
        
        plusButton.title = "+"
        
        return plusButton
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layouts)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
//    lazy var listLayout: UICollectionViewCompositionalLayout = {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//        let layout = UICollectionViewCompositionalLayout(section: section)
//
//        return layout
//    }()
//
//    lazy var gridLayout: UICollectionViewCompositionalLayout = {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(270))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//        let layout = UICollectionViewCompositionalLayout(section: section)
//
//        return layout
//    }()
    
    @objc private func switchSegment(segmentedControl: UISegmentedControl) {
        guard let layoutType = LayoutType(rawValue: segmentedControl.selectedSegmentIndex) else {
            return
        }
        
        
//        self.layoutType = layoutType
//        collectionView.collectionViewLayout = layoutType.layout()
        
//        switch layoutType {
//        case .list:
//            collectionView.collectionViewLayout = listLayout
//        case .grid:
//            collectionView.collectionViewLayout = gridLayout
//        }
        
//        collectionView.reloadData()
    }
}

// MARK: - Layout
extension ProductView {
    func configureLayout() {
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.segmentedControl.widthAnchor.constraint(equalToConstant: 170)
        ])
    }
}
