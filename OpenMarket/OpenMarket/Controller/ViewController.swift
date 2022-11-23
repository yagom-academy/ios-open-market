//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var networkCommunication = NetworkCommunication()
    
    var searchListProducts: SearchListProducts?
    var detailProduct: DetailProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        getResponseAboutHealChecker()
        getProductsListData()
        getProductDetailData(productNumber: "31")
        getCollectionViewCellNib()
    }
    
    @IBAction func tapSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            
        } else {
            
        }
        
    }
    
    private func getCollectionViewCellNib() {
        let customCollectionViewCellNib = UINib(nibName: "CustomCollectionViewGridCell", bundle: nil)
        collectionView.register(customCollectionViewCellNib, forCellWithReuseIdentifier: "customCollectionViewCell")
    }
    
    private func getResponseAboutHealChecker() {
        networkCommunication.requestHealthChecker(
            url: ApiUrl.Path.healthChecker) { response in
            switch response {
            case .success(let response):
                print("코드\(response.statusCode): 연결완료")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getProductsListData(pageNumber: String = "1", itemPerPage: String = "100") {
        networkCommunication.requestProductsInformation(
            url: ApiUrl.Path.products +
            ApiUrl.Query.pageNumber +
            pageNumber +
            ApiUrl.Query.itemsPerPage +
            itemPerPage,
            type: SearchListProducts.self
        ) { data in
            switch data {
            case .success(let data):
                self.searchListProducts = data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getProductDetailData(productNumber: String) {
        networkCommunication.requestProductsInformation(
            url: ApiUrl.Path.detailProduct + productNumber,
            type: DetailProduct.self
        ) { data in
            switch data {
            case .success(let data):
                self.detailProduct = data
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let searchListProducts = searchListProducts else { return 0 }
        return searchListProducts.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(imageSource: <#T##String#>, name: <#T##String#>, currency: <#T##Currency#>, price: <#T##Double#>, bargainPrice: <#T##Double#>, stock: <#T##Int#>)
        
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegate {
    
}
