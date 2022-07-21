//
//  OpenMarket - OpenMarketViewController.swift
//  Created by groot, bard. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class OpenMarketViewController: UIViewController {
    // MARK: - properties
    
    private var loadingView : UIView?
    private var productsList = [ProductDetail]()
    private let listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
    private lazy var listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
    lazy var listCollectionView = ListCollectionView(frame: .zero, collectionViewLayout: listLayout)
    lazy var gridCollectionView = GridCollecntionView(frame: .null, collectionViewLayout: createGridLayout())
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["List", "Grid"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    // MARK: - functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.fetchData()
        self.setUI()
    }
    
    private func fetchData() {
        let productsRequest = ProductsRequest()
        let myURLSession = MyURLSession()
        myURLSession.dataTask(with: productsRequest) {
            (result: Result<ProductsDetailList, Error>) in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.showSpinner(on: self.view)
                }
                
                success.pages.forEach { self.productsList.append($0) }
                
                self.gridCollectionView.configureSnapshot(productsList: self.productsList)
                self.listCollectionView.configureSnapshot(productsList: self.productsList)
                
                DispatchQueue.main.async {
                    self.removeSpinner()
                }
                
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    private func createGridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(LayoutSize.fractionalWidth),
                                              heightDimension: .fractionalHeight(LayoutSize.fractionalHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(GroupSize.fractionalWidth),
                                               heightDimension: .absolute(self.view.frame.height * GroupSize.frameHeightRatio))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: GroupSize.groupCount)
        group.interItemSpacing = .fixed(LayoutSize.interItemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(GroupSize.interGroupSpacing)
        section.contentInsets = NSDirectionalEdgeInsets(top: GroupSize.topEdgeInset,
                                                        leading: GroupSize.leadingEdgeInset,
                                                        bottom: GroupSize.bottomEdgeInset,
                                                        trailing: GroupSize.trailingEdgeInset)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    // MARK: - @objc functions
    
    @objc func segmentButtonDidTap(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            listCollectionView.isHidden = false
            gridCollectionView.isHidden = true
        case 1:
            listCollectionView.isHidden = true
            gridCollectionView.isHidden = false
        default:
            break
        }
    }
    
    @objc func productRegistrationButtonDidTap() {
        print("productRegistrationButtonDidTapped")
    }
}

// MARK: - extensions

extension OpenMarketViewController {
    private func showSpinner(on view : UIView) {
        let spinnerView = UIView.init(frame: view.bounds)
        spinnerView.backgroundColor = .systemGray
        spinnerView.alpha = BackgroundColor.alpha
        let activityIndicatorView = UIActivityIndicatorView.init(style: .large)
        activityIndicatorView.startAnimating()
        activityIndicatorView.center = spinnerView.center
        
        spinnerView.addSubview(activityIndicatorView)
        view.addSubview(spinnerView)
        
        loadingView = spinnerView
    }
    
    private func removeSpinner() {
        self.loadingView?.removeFromSuperview()
        self.loadingView = nil
    }
}

// MARK: - Design
// MARK: - LayoutSize

enum LayoutSize {
    static let fractionalWidth = 1.0
    static let fractionalHeight = 1.0
    static let interItemSpacing = 20.0
    static let topEdgeInset = 5
    static let leadingEdgeInset = 5
    static let bottomEdgeInset = 5
    static let trailingEdgeInset = 5
}

enum GroupSize {
    static let fractionalWidth = 1.0
    static let frameHeightRatio = 0.3
    static let groupCount = 2
    static let interGroupSpacing = 10
    static let topEdgeInset = 5.0
    static let leadingEdgeInset = 5.0
    static let bottomEdgeInset = 5.0
    static let trailingEdgeInset = 5.0
}

// MARK: - Color Literal

enum BackgroundColor {
    static let alpha = 0.5
}
