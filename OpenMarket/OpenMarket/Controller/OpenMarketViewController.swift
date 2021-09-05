//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var productList: [Product] = []
    private let networkManager = NetworkManager()
    private let parsingManager = ParsingManager()
    private let page = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let dd = Media(image: #imageLiteral(resourceName: "LoadedImageFailed"), mimeType: .png) else { return }
        let ss = MultipartFormData(title: "하하", descriptions: "호호호", price: 2000, currency: "KRW", stock: 1, discountedPrice: 200, password: "12345")
        networkManager.commuteWithAPI(api: PostAPI(parameter: ss.parameter, image: [dd])) { _ in
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: ProductCell.listNibName, bundle: nil), forCellWithReuseIdentifier: ProductCell.identifier)
//        requestProductList()
    }
}

extension OpenMarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else {
            return  UICollectionViewCell()
        }
        let productForItem = productList[indexPath.item]
        cell.imageConfigure(product: productForItem)
        cell.textConfigure(product: productForItem)
        
        return cell
    }
    
}

extension OpenMarketViewController: UICollectionViewDelegate {
    
}

extension OpenMarketViewController {
    func requestProductList() {
        self.networkManager.commuteWithAPI(api: GetItemsAPI(page: page)) { result in
            if case .success(let data) = result {
                guard let product = try? self.parsingManager.decodedJSONData(type: ProductCollection.self, data: data) else {
                    return
                }
                self.productList.append(contentsOf: product.items)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}
