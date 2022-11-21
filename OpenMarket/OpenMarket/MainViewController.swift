//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    let mainView = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        setupNavigationBar()
        setupSegmentedControlTarget()
    }
    
    func setupNavigationBar() {
        self.navigationItem.titleView = mainView.segmentedControl
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let addBarButtonItem = UIBarButtonItem(title: "+",
                                               style: .plain,
                                               target: self,
                                               action: #selector(addProduct))
        self.navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    private func setupSegmentedControlTarget() {
        mainView.segmentedControl.addTarget(self,
                                            action: #selector(segmentedControlValueChanged),
                                            for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged(sender: UISegmentedControl) {
       
    }
    
    @objc func addProduct() {
        
    }
    
    private func setupTestNetwork() {
        let networkManager = NetworkManager()
        guard let healthCheckerURL = NetworkRequest.checkHealth.requestURL else {
            return
        }
        
        networkManager.checkHealth(to: healthCheckerURL) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
        
        guard let productDetailURL = NetworkRequest.productDetail.requestURL else {
            return
        }
        
        networkManager.fetchData(to: productDetailURL, dataType: Product.self) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.description)
            }
        }
        
        guard let productListURL = NetworkRequest.productList.requestURL else {
            return
        }
        
        networkManager.fetchData(to: productListURL, dataType: ProductPage.self) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.description)
            }
        }
    }
}

// MARK: - Extention UICollectionView
extension MainViewController: UICollectionViewDelegate {
    
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.reuseIdentifier,
                                                      for: indexPath)
        
        return cell
    }
}
