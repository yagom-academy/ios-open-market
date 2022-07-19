//
//  OpenMarket - ViewController.swift
//  Created by 케이, 수꿍.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class MarketProductsViewController: UIViewController {
    private let segmentedControl = UISegmentedControl(items: ["List","Grid"])
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        fetchData()
    }
}

// MARK: Networking

extension MarketProductsViewController {
    func fetchData() {
        self.networkProvider.requestAndDecode(url: "https://market-training.yagom-academy.kr/api/products?page_no=1&items_per_page=10", dataType: ProductList.self) { result in
            switch result {
            case .success(let productList):
                productList.pages.forEach { product in
                    let item = ProductEntity(thumbnailImage: product.thumbnailImage!, name: product.name, originalPrice: product.price, discountedPrice: product.bargainPrice, stock: product.stock)
                    self.productsModel.append(item)
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.configureSegmentedControl()
                        self?.configureHierarchy()
                        self?.configureDataSource()
                        self?.collectionView.reloadData()
                    }
                }
            case .failure(let error):
                let alertController = UIAlertController(title: "알림", message: error.errorDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
            }
        }
    }
}
private extension MarketProductsViewController {
    func configureSegmentedControl() {
        let xPostion:CGFloat = 65
        let yPostion:CGFloat = 55
        let elementWidth:CGFloat = 150
        let elementHeight:CGFloat = 30
        
        segmentedControl.frame = CGRect(x: xPostion, y: yPostion, width: elementWidth, height: elementHeight)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.yellow
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        configureNavigationItems()
    }
    
    func configureNavigationItems() {
        self.navigationItem.titleView = segmentedControl
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    }
}

// MARK: UIElements Action

private extension MarketProductsViewController {
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!) {
        let items = sender.selectedSegmentIndex
        
        switch items {
        case 0 :
            collectionView.setCollectionViewLayout(createListLayout(), animated: true)
            collectionView.visibleCells.forEach { cell in
                guard let cell = cell as? CustomCollectionViewCell else {
                    return
                }
                
                cell.contentView.layer.borderColor = .none
                cell.contentView.layer.borderWidth = 0
                cell.accessories = [.disclosureIndicator()]
                
                cell.configureStackView(of: .horizontal, textAlignment: .left)
            }
        case 1:
            collectionView.setCollectionViewLayout(createGridLayout(), animated: true)
            collectionView.visibleCells.forEach { cell in
                guard let cell = cell as? CustomCollectionViewCell else {
                    return
                }
                
                isSelected = true
                cell.accessories = [.delete()]
                cell.contentView.layer.borderColor = UIColor.black.cgColor
                cell.contentView.layer.borderWidth = 1
                
                cell.configureStackView(of: .vertical, textAlignment: .center)
            }
            
            collectionView.scrollToItem(at: IndexPath(item: -1, section: 0), at: .init(rawValue: 0), animated: false)
        default:
            break
        }
    }
    
    @objc func addTapped() {
        
    }
}
