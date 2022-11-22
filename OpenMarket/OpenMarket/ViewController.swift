//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    lazy var navSegmentedView: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBlue
        return segmentedControl
    }()
    
    var collectionView: UICollectionView?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
//        setLayout()
        
        setupNavBar()
    }
    
    private func configure() {
        self.view.backgroundColor = .systemBackground
        self.navSegmentedView.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray6
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        
        self.navigationController?.navigationBar.backgroundColor = .systemGray
        
        self.navigationItem.titleView = navSegmentedView
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tappedAddButton))
            
    }
    
    @objc func tappedAddButton() {
        
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
    }
}
