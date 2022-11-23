//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    let mainView = MainView()
    var productData: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        setupNavigationBar()
        setupSegmentedControlTarget()
        setupData()
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    private func setupNavigationBar() {
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
    
    @objc func addProduct() {
        
    }
    
    private func setupSegmentedControlTarget() {
        mainView.segmentedControl.addTarget(self,
                                            action: #selector(segmentedControlValueChanged),
                                            for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            mainView.layoutStatus = .list
        } else {
            mainView.layoutStatus = .grid
        }
    }
    
    private func setupData() {
        let networkManager = NetworkManager()
        guard let productListURL = NetworkRequest.productList.requestURL else {
            return
        }
        
        networkManager.fetchData(to: productListURL, dataType: ProductPage.self) { result in
            switch result {
            case .success(let data):
                self.productData = data.pages
                
                DispatchQueue.main.async {
                    self.mainView.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.description)
            }
        }
    }
}

// MARK: - Extension UICollectionView
extension MainViewController: UICollectionViewDelegate {
    
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if mainView.layoutStatus == .list {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ListCollectionViewCell.reuseIdentifier,
                for: indexPath) as? ListCollectionViewCell
            else {
                let errorCell = UICollectionViewCell()
                return errorCell
            }
            
            DispatchQueue.main.async { [weak self] in
                if indexPath == collectionView.indexPath(for: cell) {
                    guard let data = self?.productData[indexPath.item] else { return }
                    cell.setupData(with: data)
                }
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GridCollectionViewCell.reuseIdentifier,
                for: indexPath) as? GridCollectionViewCell
            else {
                let errorCell = UICollectionViewCell()
                return errorCell
            }
            
            DispatchQueue.main.async { [weak self] in
                if indexPath == collectionView.indexPath(for: cell) {
                    guard let data = self?.productData[indexPath.item] else { return }
                    
                    cell.setupProductImage(with: data.thumbnail)
                    cell.setupData(with: data)
                }
            }
            return cell
        }
    }
}
