//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var productTableView: UITableView!
    
    var productList: ProductList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showTableViewFirst()
        
        self.productCollectionView.delegate = self
        self.productCollectionView.dataSource = self
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
                
        self.productCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        self.productTableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        loadProductList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadProductList()
    }
    
    func showTableViewFirst() {
        productTableView.isHidden = false
        productCollectionView.isHidden = true
    }
    
    @IBAction func layoutSwitch(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex  {
        case 0:
            productTableView.isHidden = false
            productCollectionView.isHidden = true
        case 1:
            productTableView.isHidden = true
            productCollectionView.isHidden = false
        default: break
        }
    }
    
    func loadProductList() {
        getDecodedData { (result: Result<ProductList, NetworkError>) in
            switch result {
            case .success(let data):
                self.productList = data
                DispatchQueue.main.async {
                    self.productTableView.reloadData()
                    self.productCollectionView.reloadData()
                }
            case .failure(let error):
                self.alertError(error)
            }
        }
    }
    
    func getDecodedData(completionHandler: @escaping (Result<ProductList, NetworkError>) -> Void) {
        let decoder = Decoder()
        let urlSessionProvider = URLSessionProvider()
        
        urlSessionProvider.getData(requestType: .productList(pageNo: 1, items: 10)) { result in
            switch result {
            case .success(let data):
                guard let parsedData: ProductList = decoder.parseJSON(data: data) else {
                    self.alertError(NetworkError.parsingFailed)
                    return
                }
                
                completionHandler(.success(parsedData))
            case .failure(_):
                return completionHandler(.failure(NetworkError.unknownFailed))
            }
        }
    }
}
