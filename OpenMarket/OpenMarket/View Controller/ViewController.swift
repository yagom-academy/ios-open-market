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

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.height / 11
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList?.productsInPage.count ?? 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCell(withIdentifier: "TableViewCell")
        
        guard let typeCastedCell = cell as? TableViewCell else {
            return cell!
        }
        
        guard let productList = productList else {
            return typeCastedCell
        }
        
        typeCastedCell.updateCellContent(withData: productList.productsInPage[indexPath.item])
        
        return typeCastedCell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width / 2 - 1) - 13
        let height = width * 1.34
        let size = CGSize(width: width, height: height)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellPedding = CGFloat(5)
        return UIEdgeInsets(top: cellPedding, left: cellPedding, bottom: cellPedding, right: cellPedding)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productList?.productsInPage.count ?? 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        
        guard let typeCastedCell = cell as? CollectionViewCell else {
            return cell
        }
        
        guard let productList = productList else {
            return typeCastedCell
        }
        
        typeCastedCell.updateCell(data: productList.productsInPage[indexPath.item])
        
        cell.layer.borderColor = UIColor.systemGray3.cgColor
        cell.layer.borderWidth = 1.5
        cell.layer.cornerRadius = 5
        
        let layout = productCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = .zero
        
        return typeCastedCell
    }
}
