//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    private var productList: [Product] = []
    private var currentCellIdentifier = ProductCell.listIdentifier
    
    @IBOutlet private weak var collectionView: ProductsCollectionView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var segmentControl: UISegmentedControl! {
        didSet {
            let normal: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
            let selected: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
            segmentControl.setTitleTextAttributes(normal, for: .normal)
            segmentControl.setTitleTextAttributes(selected, for: .selected)
            segmentControl.selectedSegmentTintColor = .white
            segmentControl.backgroundColor = .black
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        requestProducts()
    }
    
    private func collectionViewLoad() {
        DispatchQueue.main.async {
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            self.collectionView.isHidden = false
        }
    }
    
    private func requestProducts() {
        let networkManager: NetworkManager = NetworkManager()
        guard let request = networkManager.requestListSearch(page: 1, itemsPerPage: 10) else {
            showAlert(message: Message.badRequest)
            return
        }
        
        networkManager.fetch(request: request, decodingType: Products.self) { result in
            switch result {
            case .success(let products):
                self.productList = products.pages
                self.collectionViewLoad()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction private func switchSegmentedControl(_ sender: UISegmentedControl) {
        collectionView.reloadData()
        collectionView.scrollToTop()
        switch sender.selectedSegmentIndex {
        case 0:
            currentCellIdentifier = ProductCell.listIdentifier
        case 1:
            currentCellIdentifier = ProductCell.gridIdentifier
        default:
            showAlert(message: Message.unknownError)
            return
        }
    }
    
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
      cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: currentCellIdentifier,
            for: indexPath) as? ProductCell else {
            showAlert(message: Message.unknownError)
            return UICollectionViewCell()
        }
        cell.configureStyle(of: currentCellIdentifier)
        cell.configureProduct(of: productList[indexPath.row])
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let productView = collectionView as? ProductsCollectionView else {
            return CGSize()
        }
        return currentCellIdentifier == ProductCell.listIdentifier ?
        productView.listItemSize : productView.gridItemSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        guard let productView = collectionView as? ProductsCollectionView else {
            return UIEdgeInsets()
        }
        return currentCellIdentifier == ProductCell.listIdentifier ?
        productView.listSectionInset : productView.gridSectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        guard let productView = collectionView as? ProductsCollectionView else {
            return CGFloat()
        }
        return currentCellIdentifier == ProductCell.listIdentifier ?
        productView.listMinimumLineSpacing : productView.gridMinimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        guard let productView = collectionView as? ProductsCollectionView else {
            return CGFloat()
        }
        return currentCellIdentifier == ProductCell.listIdentifier ?
        productView.listMinimumInteritemSpacing : productView.gridMinimumInteritemSpacing
    }
}
