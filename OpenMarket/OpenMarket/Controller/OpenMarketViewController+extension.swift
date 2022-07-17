//
//  OpenMarketViewController.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/17.
//

import UIKit

extension OpenMarketViewController {
    func setNavigationController() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.titleView = segmentedControl
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem
        = UIBarButtonItem(image: UIImage(systemName: "plus"),
                        style: .plain,
                          target: self,
                          action: #selector(productRegistrationButtonDidTap))
    }
    
    func setSubviews() {
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.listView)
        self.view.addSubview(self.gridView)
        self.setConstraints()
    }
    
    func setSegmentedControl() {
        self.segmentedControl.addTarget(self,
                                        action: #selector(segmentButtonDidTap(sender:)),
                                        for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentButtonDidTap(sender: self.segmentedControl)
    }
    
    func setConstraints(){
        setListViewConstraints()
        setGridViewConstraints()
    }
    
    func setListViewConstraints() {
        NSLayoutConstraint.activate([
            self.listView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.listView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.listView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.listView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    func setGridViewConstraints() {
        NSLayoutConstraint.activate([
            self.gridView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.gridView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.gridView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.gridView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
    }
}
