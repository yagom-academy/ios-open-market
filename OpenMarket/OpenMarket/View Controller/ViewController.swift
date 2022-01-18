//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

@available(iOS 14.0, *)
class ViewController: UIViewController {
    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var collectionView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alpha = 0.0
    }
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tableView.alpha = 1.0
            collectionView.alpha = 0.0
        } else {
            tableView.alpha = 0.0
            collectionView.alpha = 1.0
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableViewSegue" {
            let destinationViewController = segue.destination as! TableViewController
            getDecodedData { (result: Result<ProductList, NetworkError>) in
                switch result {
                case .success(let data):
                    destinationViewController.productListData = data
                case .failure(let error):
                    print(error)
                }
            }
       } else if segue.identifier == "collectionViewSegue" {
            let destinationViewController = segue.destination as! CollectionViewController
            getDecodedData { (result: Result<ProductList, NetworkError>) in
                switch result {
                case .success(let data):
                    destinationViewController.productListData = data
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
