//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    var navSegmentedView: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBlue
        return segmentedControl
    }()
    

    var navRegisterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)

        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        self.view.backgroundColor = .systemBackground
        
        let networkManager = NetworkManager()
        
        networkManager.getHealthChecker { statusCode in
            print(statusCode)
        }
        
        networkManager.getProductDetail(productNumber: 10) { product in
            print(product)
        }
        
    }
    
    func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray6
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        
        self.navigationController?.navigationBar.backgroundColor = .systemGray
        
        self.navigationItem.titleView = navSegmentedView
        self.navigationItem.rightBarButtonItem = navRegisterButton
            
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
}
