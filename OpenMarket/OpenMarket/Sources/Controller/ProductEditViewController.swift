//
//  OpenMarket - ProductEditViewController.swift
//  Created by Zhilly, Dragon. 22/12/02
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ProductEditViewController: UIViewController {
    var imageArray: [URL?] = []
    @IBOutlet weak var mainView: ProductChangeView!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        getProduct(id: 1158) { data in
            DispatchQueue.main.async { [self] in
                for item in data.images! {
                    imageArray.append(URL(string: item.url))
                }
                mainView.configure(name: data.name, price: data.price, currency: data.currency, bargainPrice: data.bargainPrice, stock: data.stock, description: data.description)
                
                mainView.collectionView.reloadData()
            }
        }
    }
    
    private func configureCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        registerCellNib()
    }
    
    private func registerCellNib() {
        let collectionViewCellNib = UINib(nibName: ImageCollectionViewCell.stringIdentifier(), bundle: nil)
        
        mainView.collectionView.register(collectionViewCellNib,
                                         forCellWithReuseIdentifier: ImageCollectionViewCell.stringIdentifier())
    }
    
    private func getProduct(id: Int, completion: @escaping ((Product) -> Void)) {
        let session: URLSessionProtocol = URLSession.shared
        let networkManager: NetworkRequestable = NetworkManager(session: session)
        
        networkManager.request(from: URLManager.product(id: id).url, httpMethod: .get, dataType: Product.self) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(_):
                break
            }
        }
    }
}

extension ProductEditViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainView.collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.stringIdentifier(), for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.image.load(url: imageArray[indexPath.item])
        
        return cell
    }
}

extension ProductEditViewController: UICollectionViewDelegate {
    
}

