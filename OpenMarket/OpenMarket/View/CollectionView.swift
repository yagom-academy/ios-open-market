//
//  CollectionView.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

class CollectionView: UICollectionView {
  init() {
    super.init(frame: .zero, collectionViewLayout: Layout.list.builder)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  var currentLayout: Layout = .list {
    willSet {
      self.collectionViewLayout = newValue.builder
      self.reloadData()
    }
  }
  
  func configureCollectionView() {
    guard let safeArea = self.superview?.safeAreaLayoutGuide else {
      return
    }
    
    self.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      self.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
      self.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
      self.topAnchor.constraint(equalTo: safeArea.topAnchor),
      self.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
    
    self.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
    self.register(GridCell.self, forCellWithReuseIdentifier: GridCell.identifier)
  }
}
