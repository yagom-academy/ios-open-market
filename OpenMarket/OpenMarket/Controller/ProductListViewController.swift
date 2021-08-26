//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ProductListViewController: UIViewController {
    @IBOutlet private weak var openMarketCollectionView: UICollectionView!
    @IBOutlet private weak var loadingIndicatorView: UIActivityIndicatorView!
    private var networkManger = NetworkManager()
    private let imageManager = ImageManager()
    private let parsingManager = ParsingManager()
    private var nextPageNumToBring = 1
    private var productList: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        openMarketCollectionView.dataSource = self
        openMarketCollectionView.delegate = self
        openMarketCollectionView.prefetchDataSource = self
        openMarketCollectionView.register(UINib(nibName: "OpenMarketItemCell", bundle: nil), forCellWithReuseIdentifier: "OpenMarketItemCell")
        loadNextProductList(on: nextPageNumToBring)
        loadingIndicatorView.center = CGPoint(x:self.view.bounds.size.width / 2,y: self.view.bounds.size.height / 2)
        
        
    }
    
}

//MARK:- Fetch Product List
extension ProductListViewController {
    func loadNextProductList(on pageNum: Int) {
        loadingIndicatorView.startAnimating()
        
        networkManger.lookUpProductList(on: pageNum) { result in
            self.loadingIndicatorView.stopAnimating()
            switch result {
            case .success(let fetchedData):
                self.handleFetchedList(data: fetchedData)
            case .failure(let error):
                break
            }
        }
    }
    
    func handleFetchedList(data: Data) {
        let parsedResult = parsingManager.decode(from: data, to: Products.self)
        switch parsedResult {
        case .success(let products):
            let indexOffset = -1
            let startPoint = productList.count
            let endPoint = productList.count + products.items.count + indexOffset
    
            productList.append(contentsOf: products.items)
            reloadCollectionView(from: startPoint, to: endPoint)
            nextPageNumToBring += 1
        case .failure(let error):
            break
        }
    }
    
    func reloadCollectionView(from startPoint: Int, to endPoint: Int) {
        let indexPaths = (startPoint...endPoint).map { IndexPath(item: $0, section: 0) }
        openMarketCollectionView.insertItems(at: indexPaths)
    }
    
}

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OpenMarketItemCell", for: indexPath)
        guard let customCell = cell as? OpenMarketItemCell else {
            return cell
        }
        
        let product = productList[indexPath.item]
        var imageDataTask: URLSessionDataTask? = nil
        
        if let validThumbnail = product.thumbnails.first {
            imageDataTask = imageManager.fetchImage(from: validThumbnail) { result in
                switch result {
                case .success(let image):
                    customCell.configure(image: image)
                case .failure:
                    customCell.configure(image: #imageLiteral(resourceName: "ErrorImage"))
                }
            }
        }
        
        customCell.configure(from: product, with: imageDataTask)
        return customCell
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let collectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        let edgeSpace: CGFloat = 4
        let numberOfColumn: CGFloat = 2
        let heightRatioToWidth: CGFloat = 1.5
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: edgeSpace, left: edgeSpace, bottom: edgeSpace, right: edgeSpace)
        let collectionViewBounds = collectionView.bounds
        let cellWidth = (collectionViewBounds.width - collectionViewFlowLayout.sectionInset.left - collectionViewFlowLayout.sectionInset.right - collectionViewFlowLayout.minimumInteritemSpacing) / numberOfColumn
        let cellHeight = cellWidth * heightRatioToWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension ProductListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.item  == productList.count - 1{
                loadNextProductList(on: nextPageNumToBring)
            }
        }
    }
}
