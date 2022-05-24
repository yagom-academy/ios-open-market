//
//  EditView.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/24.
//

import UIKit

class EditView: UIView {
    
    private lazy var baseStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [collectionView])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .horizontalGrid)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubview(baseStackView)
        
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            baseStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            baseStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2)
        ])
    }
}

private extension UICollectionViewLayout {
    static let horizontalGrid: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
}
