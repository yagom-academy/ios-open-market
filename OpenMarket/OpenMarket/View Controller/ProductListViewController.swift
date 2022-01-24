//
//  OpenMarket - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var switchLayoutSegmentedControl: UISegmentedControl!
    private var productListData: ProductList?

    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = flowLayout
               
        loadData { (result: Result<ProductList, NetworkError>) in
            switch result {
            case .success(let data):
                self.productListData = data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction private func switchLayout(_ sender: Any) {
        self.collectionView.reloadData()
    }
    
    private func loadData(completionHandler: @escaping (Result<ProductList, NetworkError>) -> Void) {
        let urlSessionProvider = URLSessionProvider()
        
        urlSessionProvider.getData(requestType: .productList(pageNo: 1, items: 20)) { result in
            switch result {
            case .success(let data):
                guard let parsedData: ProductList = self.getParsedData(data: data) else {
                    return
                }
                completionHandler(.success(parsedData))
            case .failure(_):
                return completionHandler(.failure(NetworkError.emptyValue))
            }
        }
    }
    
    private func getParsedData(data: Data) -> ProductList? {
        let decoder = Decoder()
        var parsedData: ProductList? = nil

        let result = decoder.parsePageJSON(data: data)
        switch result {
        case .success(let data):
            parsedData = data
        case .failure(let error):
            print(error.localizedDescription)
        }
        return parsedData
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
        if switchLayoutSegmentedControl.selectedSegmentIndex == 0 {
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
        if switchLayoutSegmentedControl.selectedSegmentIndex == 0 {
            return CGSize(width: collectionView.frame.width, height: 65)
        } else {
            let width = collectionView.frame.width
            let itemsPerRow: CGFloat = 2
            let cellWidth = (width - itemsPerRow * 7) / itemsPerRow
            return CGSize(width: cellWidth, height: 300)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if switchLayoutSegmentedControl.selectedSegmentIndex == 0 {
            return 0
        } else {
            return 12
        }
    }
}
