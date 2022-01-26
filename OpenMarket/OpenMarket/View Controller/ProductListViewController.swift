//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var switchLayoutController: UISegmentedControl!
    private let dataManager = DataManager()
    private var productListData: ProductList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = flowLayout
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        
        dataManager.loadData { [weak self](result: Result<ProductList, NetworkError>) in
            switch result {
            case .success(let data):
                self?.productListData = data
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func pullToRefresh(_ sender: Any) {
        viewDidLoad()
    }
    
    @IBAction private func switchLayout(_ sender: Any) {
        self.collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let postProductView = segue.destination as? EditProductViewController {
            postProductView.productNavigationBar.title = "상품등록"
        }
    }
}

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productListData?.productsInPage.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let productListData = productListData else {
            return UICollectionViewCell()
        }
        if switchLayoutController.selectedSegmentIndex == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as? ListCell else {
                return ListCell()
            }
            cell.updateListCell(productData: productListData.productsInPage[indexPath.item])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as? GridCell else {
                return GridCell()
            }
            cell.updateGridCell(productData: productListData.productsInPage[indexPath.item])
            return cell
        }
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if switchLayoutController.selectedSegmentIndex == 0 {
            return CGSize(width: collectionView.frame.width, height: 65)
        } else {
            let width = collectionView.frame.width
            let itemsPerRow: CGFloat = 2
            let cellWidth = (width - itemsPerRow * 7) / itemsPerRow
            return CGSize(width: cellWidth, height: 300)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if switchLayoutController.selectedSegmentIndex == 0 {
            return 0
        } else {
            return 12
        }
    }
}
