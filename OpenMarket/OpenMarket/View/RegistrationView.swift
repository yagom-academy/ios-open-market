//
//  RegistrationView.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/12/02.
//

import UIKit

class RegistrationView: UIView {
    var imageCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.backgroundColor = .systemBackground
        self.addSubview(imageCollectionView)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2),
        ])
    }
}
