//
//  OpenMarketViewController.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/17.
//

import UIKit

extension OpenMarketViewController {
    //MARK: - Name space
    
    var plusButtonName : String {
        "plus"
    }
    
    //MARK: - View layout functions
    
    func setUI(){
        self.setSubviews()
        self.setNavigationController()
        self.setSegmentedControl()
        self.setListViewConstraints()
        self.setGridViewConstraints()
    }
    
    func setSubviews() {
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.gridCollectionView)
        self.view.addSubview(self.listCollectionView)
    }
    
    func setNavigationController() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.titleView = segmentedControl
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem
        = UIBarButtonItem(image: UIImage(systemName: plusButtonName),
                          style: .plain,
                          target: self,
                          action: #selector(productRegistrationButtonDidTap))
    }
    
    func setSegmentedControl() {
        self.segmentedControl.addTarget(self,
                                        action: #selector(segmentButtonDidTap(sender:)),
                                        for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
        
    }
    
    func setListViewConstraints() {
        NSLayoutConstraint.activate([
            self.listCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.listCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.listCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.listCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    func setGridViewConstraints() {
        NSLayoutConstraint.activate([
            self.gridCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.gridCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.gridCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.gridCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
    }
}
