//
//  OpenMarket - ListViewController.swift
//  Created by Zhilly, Dragon. 22/11/14
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    var product: ProductList?
    let networkManager: NetworkRequestable = NetworkManager(session: URLSession.shared)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async {
            self.loadData { data in
                DispatchQueue.main.sync {
                    self.configureCollectionView()
                }
            }
        }
    }
    
    func loadData(complete: @escaping(ProductList) -> ()) {
        networkManager.request(from: URLManager.productList(pageNumber: 1, itemsPerPage: 200).url, httpMethod: HttpMethod.get, dataType: ProductList.self) { result in
            switch result {
            case .success(let data):
                self.product = data
                complete(data)
            case .failure(_):
                break
            }
        }
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let collectionViewCellNib = UINib(nibName: String(describing: ListCollectionViewCell.self), bundle: nil)
        
        self.collectionView.register(collectionViewCellNib, forCellWithReuseIdentifier: String(describing: ListCollectionViewCell.self))
    }
}

extension ListViewController: UICollectionViewDelegate {
    
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let count: Int = product?.pages.count else {
            return 0
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as! ListCollectionViewCell
        
        guard let product = product else { return cell }
        let productItem = product.pages[indexPath.item]
        
        cell.configurationCell(item: productItem)
        //collectionView.reloadData()
        
        return cell
    }
}

