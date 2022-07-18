//
//  OpenMarket - OpenMarketViewController.swift
//  Created by groot, bard. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["List", "Grid"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    let listView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let listView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        listView.backgroundColor = .green
        listView.translatesAutoresizingMaskIntoConstraints = false
        
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return listView
    }()
    
    let gridView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let gridView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        gridView.backgroundColor = .yellow
        gridView.translatesAutoresizingMaskIntoConstraints = false
        
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return gridView
    }()
    
    var shouldHideListView: Bool? {
        didSet {
            guard let shouldHideListView = self.shouldHideListView else { return }
            self.listView.isHidden = shouldHideListView
            self.gridView.isHidden = !self.listView.isHidden
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setSubviews()
        self.setNavigationController()
        self.setSegmentedControl()
    }
    
    @objc func segmentButtonDidTap(sender: UISegmentedControl) {
        self.shouldHideListView = (sender.selectedSegmentIndex != 0)
        print(self.listView.isHidden)
    }
    
    @objc func productRegistrationButtonDidTap() {
        print("productRegistrationButtonDidTapped")
    }
}
