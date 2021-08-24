//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var productListCollectionView: UICollectionView!
    @IBOutlet weak var loadListIndicator: UIActivityIndicatorView!

    let networkManager = NetworkManager()
    let parsingManager = ParsingManager()
    var currentPage = 1
    var productList = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureCollectionView()
        loadListIndicator.hidesWhenStopped = true
        loadProductList(page: currentPage)
    }
    
    private func configureNavigationItem() {
        self.navigationItem.title = "야아 마켓"
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = addBarButton
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        guard let collectionView = productListCollectionView else { return }
        collectionView.register(ProductListCustomCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductListCustomCollectionViewCell.identifier)
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    private func loadProductList(page: Int) {
        loadListIndicator.startAnimating()
        self.currentPage = page + 1
        let apiModel = GetAPI.lookUpProductList(page: page, contentType: .noBody)
        networkManager.request(apiModel: apiModel) { [self] result in
            switch result {
            case .success(let data):
                guard let parsingData = parsingManager.decodingData(data: data, model: Page.self),
                      !parsingData.products.isEmpty else { return }
                for product in parsingData.products {
                    productList.append(product)
                    DispatchQueue.main.async {
                        loadListIndicator.stopAnimating()
                        self.productListCollectionView?.reloadData()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.item == self.productList.count - 20 {
            loadProductList(page: currentPage)
        }
    }
}

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCustomCollectionViewCell.identifier, for: indexPath) as? ProductListCustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(productList[indexPath.row])
        
        return cell
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2-10, height: collectionView.frame.height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        return inset
    }
}


