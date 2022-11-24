//
//  OpenMarket - ProductsViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ProductsViewController: UIViewController {
    var productsData: ProductListResponse? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    let productResponseNetworkManager = NetworkManager<ProductListResponse>()
    var currentPage: Int = 1
    
    enum Constant {
        static let edgeInsetValue: CGFloat = 8
    }
    
    var segmentIndex = 0
    
    let addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        
        return button
    }()
    
    lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["LIST", "GRID"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(didChangedSegmentIndex(_:)), for: .valueChanged)

        return segment
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(
            top: Constant.edgeInsetValue,
            left: Constant.edgeInsetValue,
            bottom: 0,
            right: Constant.edgeInsetValue
        )

        collectionView.register(
            ProductItemCell.self,
            forCellWithReuseIdentifier: ProductItemCell.identifier
        )
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.titleView = segment
        
        self.view = collectionView
        fetchData()
    }
    
    func fetchData() {
        let endPoint = OpenMarketAPI.productsList(pageNumber: currentPage, rowCount: 200)
        productResponseNetworkManager.fetchData(endPoint: endPoint) { result in
            switch result {
            case .success(let data):
                self.productsData = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func didChangedSegmentIndex(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        
        segmentIndex = index
        collectionView.reloadData()
    }
}

extension ProductsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let size = collectionView.bounds.size
        let index = (segmentIndex + 1)
        let contentsWidth = (size.width / CGFloat(index)) - (2 * Constant.edgeInsetValue)
        let contentsHeight = index == 1 ? size.height * 0.1 : size.height * 0.3
         
        return CGSize(width: contentsWidth, height: contentsHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constant.edgeInsetValue
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constant.edgeInsetValue
    }
}

extension ProductsViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let products = productsData?.products else { return 0 }
        return products.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let products = productsData?.products else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductItemCell.identifier,
            for: indexPath
        ) as? ProductItemCell else {
            return UICollectionViewCell()
        }
        
        let product = products[indexPath.row]
        
        cell.configureLayout(index: segmentIndex)
        cell.titleLabel.text = product.name
//        cell.subTitleLabel.text = "\(product.currency.rawValue) \(product.price)"
        cell.setPriceLabel(currency: product.currency.rawValue, price: product.price, bargainPrice: product.bargainPrice, segment: 1)
        cell.setStockLabelValue(stock: product.stock)
        
        guard let url = URL(string: product.thumbnail) else { return cell }
        let imageTask = URLSession.createTask(url: url) { image in
            DispatchQueue.main.async {
                cell.thumbnailImageView.image = image
            }
        }
        
        cell.task = imageTask
        return cell
    }
}

private extension URLSession {
    static func createTask(
        url: URL,
        completion: @escaping (UIImage?) -> Void
    ) -> URLSessionDataTask {
        Self.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else { return }
            
            if let data = data {
                let image = UIImage(data: data)
                completion(image)
            }
        }
    }
}
