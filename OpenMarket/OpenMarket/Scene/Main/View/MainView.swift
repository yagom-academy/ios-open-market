//
//  MainView.swift
//  OpenMarket
//
//  Created by Red, Mino on 2022/05/10.
//

import UIKit

final class MainView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setUpAttribute()
        registerCollectionViewCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        setUpAttribute()
        registerCollectionViewCell()
    }
    
    enum LayoutStatus: Int {
        case list = 0
        case grid = 1
    }
    
    var layoutStatus: LayoutStatus = .list {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["LIST", "GRID"])
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    let addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: listLayout)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    private let listLayout: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.15)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }()
    
    private let gridLayout: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/2),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.3)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(14)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 8,
            bottom: 10,
            trailing: 8
        )
        section.interGroupSpacing = 8
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    private func addSubviews() {
        addSubview(collectionView)
    }
    
    private func setUpAttribute() {
        backgroundColor = .white
    }
    
    private func registerCollectionViewCell() {
        collectionView.register(
            ProductsListCell.self,
            forCellWithReuseIdentifier: ProductsListCell.identifier
        )
        
        collectionView.register(
            ProductsGridCell.self,
            forCellWithReuseIdentifier: ProductsGridCell.identifier
        )
    }
    
    func setUpLayout(segmentIndex: Int) {
        guard let layoutStatus = LayoutStatus(rawValue: segmentIndex) else {
            return
        }
        
        switch layoutStatus {
        case .list:
            collectionView.collectionViewLayout = listLayout
            setUpListScroll()
            self.layoutStatus = .list
        case .grid:
            collectionView.collectionViewLayout = gridLayout
            setUpGridScroll()
            self.layoutStatus = .grid
        }
    }
    
    private func setUpListScroll() {
        let currentOffset = collectionView.contentOffset
        
        guard currentOffset.y > 0 else { return }
        
        collectionView.setContentOffset(
            CGPoint(
                x: currentOffset.x,
                y: currentOffset.y + collectionView.frame.height * 0.3 - 10
            ), animated: false
        )
    }
    
    private func setUpGridScroll() {
        let currentOffset = collectionView.contentOffset
        collectionView.setContentOffset(
            CGPoint(
                x: currentOffset.x,
                y: currentOffset.y - collectionView.frame.height * 0.3 + 10
            ), animated: false
        )
    }
}
