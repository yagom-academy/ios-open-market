//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    let listView = ListViewController()
    let gridView = GridViewController()
    let listPresentingStyleSelection = ["LIST","GRID"]
    lazy var listPresentingStyleSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: listPresentingStyleSelection)
        control.selectedSegmentIndex = 0
        control.layer.borderColor = UIColor.systemBlue.cgColor
        control.tintColor = .systemBlue
        control.selectedSegmentTintColor = .systemBlue
        control.addTarget(self, action: #selector(didTapSegment(segment:)), for: .valueChanged)
        return control
    }()
    lazy var addProductButton: UIBarButtonItem = {
        let button =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
        setUpView()
        
        let testProduct = ProductRegistration(title: "오늘의태태6", descriptions: "hihi", price: 50000, currency: "KRW", stock: 50, discountedPrice: nil, images: [], password: "1234")

        OpenMarketAPIManager().requestRegistration(product: testProduct) { (result) in
            switch result {
            case .success(let testProduct):
                print(testProduct)
            case .failure(let error):
                print(error)
            }
        }
//        OpenMarketAPIManager().requestProduct(of: 90) { (result) in
//            switch result {
//            case .success(let product):
//                print(product)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    @objc private func didTapSegment(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            listView.view.isHidden = false
            gridView.view.isHidden = true
        }
        else {
            gridView.view.isHidden = false
            listView.view.isHidden = true
        }
    }
    
    private func setUpView() {
        addChild(listView)
        addChild(gridView)
        
        self.view.addSubview(listView.view)
        self.view.addSubview(gridView.view)
        
        listView.didMove(toParent: self)
        gridView.didMove(toParent: self)
        
        listView.view.frame = self.view.bounds
        gridView.view.frame = self.view.bounds
        
        gridView.view.isHidden = true
    }
    
    private func setUpNavigationItem() {
        self.navigationItem.titleView = listPresentingStyleSegmentControl
        self.navigationItem.rightBarButtonItem = addProductButton
    }
    
    @objc private func addButtonTapped(_ sender: Any) {
        print("button pressed")
    }
}

