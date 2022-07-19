//
//  OpenMarket - OpenMarketViewController.swift
//  Created by groot, bard. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class OpenMarketViewController: UIViewController {
    // MARK: - properties
    
    var loadingView : UIView?
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
    
    private var shouldHideListView: Bool? {
        didSet {
            guard let shouldHideListView = self.shouldHideListView else { return }
            self.listCollectionView.isHidden = shouldHideListView
            self.gridCollectionView.isHidden = !self.listCollectionView.isHidden
        }
    }
    
    // MARK: - functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.showSpinner(on: self.view)
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
                for number in 0...29 {
                    self.productsList.append(success.pages[number])
                }
                if self.productsList.count == 30 {
                    self.gridCollectionView.configureSnapshot(productsList: self.productsList)
                    self.listCollectionView.configureSnapshot(productsList: self.productsList)
                }
                self.removeSpinner()
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    private func createGridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(self.view.frame.height * 0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: 2)
        group.interItemSpacing = .fixed(20)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(10)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5,
                                                        leading: 5,
                                                        bottom: 5,
                                                        trailing: 5)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    // MARK: - @objc functions
    
    @objc func segmentButtonDidTap(sender: UISegmentedControl) {
        self.shouldHideListView = (sender.selectedSegmentIndex != 0)
    }
    
    @objc func productRegistrationButtonDidTap() {
        print("productRegistrationButtonDidTapped")
    }
}

// MARK: - extensions

extension OpenMarketViewController {
    private func showSpinner(on view : UIView) {
        let spinnerView = UIView.init(frame: view.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicatorView = UIActivityIndicatorView.init(style: .large)
        activityIndicatorView.startAnimating()
        activityIndicatorView.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(activityIndicatorView)
            view.addSubview(spinnerView)
        }
        
        loadingView = spinnerView
    }
    
    private func removeSpinner() {
        DispatchQueue.main.async {
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
        }
    }
}
