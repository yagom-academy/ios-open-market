//
//  ProductListView.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/16.
//

import UIKit

final class ProductListView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
        self.addSubview(indicatorView)
        segmentedControl.addTarget(self, action: #selector(switchSegment(segmentedControl:)), for: .valueChanged)
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var layoutType: LayoutType = .list {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private lazy var layouts: UICollectionViewCompositionalLayout = {
        return UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            return LayoutType.section(self.layoutType)()
        }, configuration: .init())
    }()

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
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layouts)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }()
    
    @objc private func switchSegment(segmentedControl: UISegmentedControl) {
        guard let layoutType = LayoutType(rawValue: segmentedControl.selectedSegmentIndex) else {
            return
        }
        
        self.layoutType = layoutType
    }
}

// MARK: - Layout
extension ProductListView {
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
        
        NSLayoutConstraint.activate([
            self.indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
