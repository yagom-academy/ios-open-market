//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

enum Section: Int {
    case main
}

struct Product: APIable {
    var hostAPI: String = "https://market-training.yagom-academy.kr"
    var path: String = "/api/products"
    var param: [String : String]? = [
        "page_no": "1",
        "items_per_page": "10"
    ]
    var method: HTTPMethod = .get
}

final class ViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ProductsDetail>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ProductsDetail>
    
    lazy var productView = ProductView.init(frame: view.bounds)
    private lazy var dataSource = makeDataSource()
    let networkManager = NetworkManager<Products>(session: URLSession.shared)
    let product = Product()
    var item: [ProductsDetail] = []{
        didSet {
            DispatchQueue.main.async {
                self.applySnapshot()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        productView.collectionView.dataSource = self.dataSource
        productView.collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
        productView.collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        DispatchQueue.global().async {
            self.networkManager.execute(with: self.product) { result in
                switch result {
                case .success(let result):
                    self.item = result.pages
                    dispatchGroup.leave()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        applySnapshot()
    }
    
    private func configureView() {
        self.view = productView
        view.backgroundColor = .white
        navigationItem.titleView = productView.segmentedControl
        navigationItem.rightBarButtonItem = productView.plusButton
        
        NSLayoutConstraint.activate([
            productView.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productView.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            productView.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            productView.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        productView.configureLayout()
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: productView.collectionView,
            cellProvider: { (collectionView, indexPath, productDetail) -> UICollectionViewCell? in
                
                if self.productView.segmentedControl.selectedSegmentIndex == 1 {
                    guard let cell = self.productView.collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    
                    if self.item[indexPath.row].discountedPrice != 0 {
                        let currency = self.item[indexPath.row].currency
                        let price = String(self.item[indexPath.row].price)
                        let bargain = String(self.item[indexPath.row].bargainPrice)
                        
                        cell.originalPrice.text = currency + price
                        cell.makeBargainPrice(price: cell.originalPrice)
                        cell.discountedPrice.text = currency + bargain
                    }
                    
                    cell.productName.text = self.item[indexPath.row].name
                    cell.currency.text = self.item[indexPath.row].currency
                    cell.price.text = String(self.item[indexPath.row].price)
                    cell.stock.text = String(self.item[indexPath.row].stock)
                    
                    guard let data = try? Data(contentsOf: self.item[indexPath.row].thumbnail) else {
                        return UICollectionViewCell()
                    }
                    
                    cell.productImage.image = UIImage(data: data)
                    
                    cell.configureProductUI()
                    
                    return cell
                } else {
                    guard let cell = self.productView.collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as? ListCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    
                    if self.item[indexPath.row].discountedPrice != 0 {
                        let currency = self.item[indexPath.row].currency
                        let price = String(self.item[indexPath.row].price)
                        let bargain = String(self.item[indexPath.row].bargainPrice)
                        
                        cell.originalPrice.text = currency + price
                        cell.makeBargainPrice(price: cell.originalPrice)
                        cell.discountedPrice.text = currency + bargain
                    }
                    
                    cell.productName.text = self.item[indexPath.row].name
                    cell.currency.text = self.item[indexPath.row].currency
                    cell.price.text = String(self.item[indexPath.row].price)
                    cell.stock.text = String(self.item[indexPath.row].stock)
                    
                    if self.item[indexPath.row].discountedPrice != 0 {
                        cell.currency.text = self.item[indexPath.row].currency
                        cell.price.text = String(self.item[indexPath.row].price)
                        cell.bargainPrice.text = String(self.item[indexPath.row].bargainPrice)
                    }
                    
                    guard let data = try? Data(contentsOf: self.item[indexPath.row].thumbnail) else {
                        return UICollectionViewCell()
                    }
                    
                    cell.productImage.image = UIImage(data: data)
                    
                    cell.configurePriceUI()
                    cell.configureProductUI()
                    cell.configureProductWithImageUI()
                    cell.configureAccessoryStackView()
                    
                    return cell
                }
            })
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        snapShot.appendItems(item)
        dataSource.apply(snapShot, animatingDifferences: animatingDifferences)
    }
}
