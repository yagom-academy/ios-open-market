//
//  MainView.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/21.
//

import UIKit

enum CollectionStatus: Int {
    case list
    case grid
}

final class MainView: UIView {
    var layoutStatus: CollectionStatus = .list {
        didSet {
            changeLayout()
            scrollViewTop()
            collectionView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupUI()
        registerCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["LIST", "GRID"])
        control.selectedSegmentIndex = 0
        control.layer.borderWidth = 1
        control.layer.borderColor = UIColor.blue.cgColor
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue],
                                       for: UIControl.State.normal)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white],
                                       for: UIControl.State.selected)
        control.selectedSegmentTintColor = .blue
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let listLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let collectionCellWidth = UIScreen.main.bounds.width
        let collectionCellHeight = UIScreen.main.bounds.height / 11
        layout.itemSize  = CGSize(width: collectionCellWidth, height: collectionCellHeight)
        return layout
    }()
    
    private let gridLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        let collectionCellWidth = UIScreen.main.bounds.width / 2 - 15
        let collectionCellHeight = UIScreen.main.bounds.height / 3
        layout.itemSize  = CGSize(width: collectionCellWidth, height: collectionCellHeight)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: listLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private func registerCell() {
        collectionView.register(ListCollectionViewCell.self,
                                forCellWithReuseIdentifier: ListCollectionViewCell.reuseIdentifier)
        collectionView.register(GridCollectionViewCell.self,
                                forCellWithReuseIdentifier: GridCollectionViewCell.reuseIdentifier)
    }
    
    private func changeLayout() {
        switch layoutStatus {
        case .list:
            collectionView.collectionViewLayout = listLayout
        case .grid:
            collectionView.collectionViewLayout = gridLayout
        }
    }
    
    private func scrollViewTop(){
        self.layoutIfNeeded()
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
}

// MARK: - UI Constraint
extension MainView {
    private func setupUI() {
        self.addSubview(segmentedControl)
        self.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                    constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -10)
        ])
    }
}
