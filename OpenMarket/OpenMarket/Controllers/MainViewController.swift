//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    private let networkManager = NetworkManager()
    private let mainView = MainView()
    
    private var productData: [Product] = []
    private var pageCount = Constant.pageNumberUnit.rawValue
    private var scrollState = ScrollState.idle
    
    private enum Constant: Int {
        case pageNumberUnit = 1
        case itemsPerPage = 10
    }
    
    private enum ScrollState {
        case idle
        case isLoading
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        setupNavigationBar()
        setupSegmentedControlTarget()
        
        setupData(pageNo: pageCount, itemsPerPage: Constant.itemsPerPage.rawValue)
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    private func setupData(pageNo: Int, itemsPerPage: Int) {
        guard scrollState == .idle else { return }
        scrollState = .isLoading
        guard let productListURL = NetworkRequest.productList(
            pageNo: pageNo, itemsPerPage: itemsPerPage).requestURL else { return }
        
        networkManager.fetchData(to: productListURL, dataType: ProductPage.self) { result in
            switch result {
            case .success(let data):
                self.productData = data.pages
                DispatchQueue.main.async {
                    self.mainView.collectionView.reloadData()
                    self.scrollState = .idle
                }
            case .failure(let error):
                print(error.description)
            }
        }
    }
}

// MARK: - UI & UIAction
extension MainViewController {
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
        let addViewController = AddViewController()
        addViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(addViewController, animated: true)
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
}

// MARK: - Extension UICollectionView
extension MainViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let collectionViewContentSizeY = scrollView.contentSize.height
        let contentOffsetY = scrollView.contentOffset.y
        let heightRemainBottomHeight = collectionViewContentSizeY - contentOffsetY
        let frameHeight = scrollView.frame.size.height
        
        if heightRemainBottomHeight < frameHeight {
            pageCount += Constant.pageNumberUnit.rawValue
            self.setupData(pageNo: pageCount, itemsPerPage: Constant.itemsPerPage.rawValue)
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return productData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch mainView.layoutStatus {
        case .list:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ListCollectionViewCell.reuseIdentifier,
                for: indexPath) as? ListCollectionViewCell
            else {
                let errorCell = UICollectionViewCell()
                return errorCell
            }
            
            cell.indicatorView.startAnimating()
            
            let data = self.productData[indexPath.item]
            cell.setupData(with: data)
            
            let cacheKey = NSString(string: data.thumbnail)
            if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
                cell.uploadImage(cachedImage)
                return cell
            }
            
            networkManager.fetchImage(with: data.thumbnail) { image in
                DispatchQueue.main.async {
                    if indexPath == collectionView.indexPath(for: cell) {
                        ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                        cell.uploadImage(image)
                    }
                }
            }
            return cell
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GridCollectionViewCell.reuseIdentifier,
                for: indexPath) as? GridCollectionViewCell
            else {
                let errorCell = UICollectionViewCell()
                return errorCell
            }
            
            cell.indicatorView.startAnimating()
            
            let data = self.productData[indexPath.item]
            cell.setupData(with: data)
            
            let cacheKey = NSString(string: data.thumbnail)
            if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
                cell.uploadImage(cachedImage)
                return cell
            }
            
            networkManager.fetchImage(with: data.thumbnail) { image in
                DispatchQueue.main.async {
                    if indexPath == collectionView.indexPath(for: cell) {
                        ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                        cell.uploadImage(image)
                    }
                }
            }
            return cell
        }
    }
}
