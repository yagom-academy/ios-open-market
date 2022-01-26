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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productTableView.isHidden = false
        productCollectionView.isHidden = true
        
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
    
    func loadProductList() {
        getDecodedData { (result: Result<ProductList, NetworkError>) in
            switch result {
            case .success(let data):
                self.productList = data
                DispatchQueue.main.async {
                    self.productCollectionView.reloadData()
                    self.productTableView.reloadData()
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
                guard let parsedData: ProductList = decoder.parseJSON(data: data) else {
                    print(NetworkError.parsingFailed)
                    return
                }
                
                completionHandler(.success(parsedData))
            case .failure(_):
                return completionHandler(.failure(NetworkError.unknownFailed))
            }
        }
    }
}
