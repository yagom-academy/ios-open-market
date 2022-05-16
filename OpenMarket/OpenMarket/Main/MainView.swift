//
//  MainView.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/12.
//

import UIKit

enum CollectionLayout: Int {
    case list = 0
    case grid = 1
    
    var cellType: ProductCell.Type {
        switch self {
        case .list:
            return ProductListCell.self
        case .grid:
            return ProductGridCell.self
        }
    }
}

final class MainView: UIView {
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .list)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - MainView Method

extension MainView {
    private func configureLayout() {
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func changeLayout(index selectedIndex: Int) {
        guard let layout = CollectionLayout(rawValue: selectedIndex) else { return }
        
        switch layout {
        case .list:
            collectionView.collectionViewLayout = .list
        case .grid:
            collectionView.collectionViewLayout = .grid
        }
    }
}
