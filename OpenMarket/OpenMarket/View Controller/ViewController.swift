//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var productListData: ProductList?

    @IBOutlet weak var switchLayoutController: UISegmentedControl!
    @IBAction func switchLayout(_ sender: Any) {
        self.collectionView.reloadData()
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = flowLayout
               
        getDecodedData { (result: Result<ProductList, NetworkError>) in
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
    
    func getDecodedData(completionHandler: @escaping (Result<ProductList, NetworkError>) -> Void) {
        let decoder = Decoder()
        let urlSessionProvider = URLSessionProvider()
        
        urlSessionProvider.getData(requestType: .productList(pageNo: 1, items: 10)) { result in
            switch result {
            case .success(let data):
                guard let parsedData: ProductList = decoder.parsePageJSON(data: data) else {
                    return
                }
                completionHandler(.success(parsedData))
            case .failure(_):
                return completionHandler(.failure(NetworkError.unknownFailed))
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productListData?.productsInPage.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        guard let emptyCell = cell as? CollectionViewCell else {
            return cell
        }
        
        guard let productListData = productListData else {
            return emptyCell
        }
        
        if switchLayoutController.selectedSegmentIndex == 0 {

        emptyCell.layer.cornerRadius = 10
        emptyCell.layer.borderWidth = 2
        emptyCell.layer.borderColor = UIColor.systemGray2.cgColor
        emptyCell.updateGridCell(data: productListData, indexPathItem: indexPath.item)
        
        } else {
            emptyCell.layer.cornerRadius = 0
            emptyCell.layer.borderWidth = 0
            emptyCell.layer.borderColor = .none
            emptyCell.updateListCell(data: productListData, indexPathItem: indexPath.item)

        }
        
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if switchLayoutController.selectedSegmentIndex == 0 {
            let width = collectionView.frame.width
            let itemsPerRow: CGFloat = 2
            let cellWidth = (width - itemsPerRow * 7) / itemsPerRow

            return CGSize(width: cellWidth, height: 270)
        } else {
            print("fsddfs")
            let width = collectionView.frame.width

            return CGSize(width: width, height: 50)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if switchLayoutController.selectedSegmentIndex == 0 {
            return 7
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if switchLayoutController.selectedSegmentIndex == 0 {
            return 10
        } else {
            return 0
        }    }
    
}

extension ViewController: UICollectionViewDelegate {
    
}
