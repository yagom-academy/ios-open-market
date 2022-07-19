//
//  OpenMarket - OpenMarketViewController.swift
//  Created by groot, bard. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {    
    var loadingView : UIView?
    var productsList = [ProductDetail]()
    let listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
    lazy var listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
    lazy var listCollectionView = ListCollectionView(frame: .zero, collectionViewLayout: listLayout)
    lazy var gridCollectionView = GridCollecntionView(frame: .null, collectionViewLayout: createGridLayout())
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["List", "Grid"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    var shouldHideListView: Bool? {
        didSet {
            guard let shouldHideListView = self.shouldHideListView else { return }
            self.listCollectionView.isHidden = shouldHideListView
            self.gridCollectionView.isHidden = !self.listCollectionView.isHidden
        }
    }
    
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
    
    func createGridLayout() -> UICollectionViewCompositionalLayout {
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
    
    @objc func segmentButtonDidTap(sender: UISegmentedControl) {
        self.shouldHideListView = (sender.selectedSegmentIndex != 0)
    }
    
    @objc func productRegistrationButtonDidTap() {
        print("productRegistrationButtonDidTapped")
    }
    
}
