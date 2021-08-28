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
        
        productListCollectionView.register(UICollectionViewCell.nib(), forCellWithReuseIdentifier: ProductListCustomCollectionViewCell.identifier)
        
        productListCollectionView.collectionViewLayout = layout
        productListCollectionView.delegate = self
        productListCollectionView.dataSource = self
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
    
    private func generateCostomCellTitleLabel(product: Product, titleLabel: UILabel) -> UILabel {
        titleLabel.text = product.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        return titleLabel
    }
    
    private func generateCustomCellPriceLabel(product: Product, priceLabel: UILabel) -> UILabel {
        let text = "\(product.currency)\(product.price)"
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: text)
        if product.discountedPrice != nil {
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: range)
            priceLabel.attributedText = attributedString
            priceLabel.textColor = .red
        } else {
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: range)
            priceLabel.attributedText = attributedString
            priceLabel.textColor = .lightGray
        }
        return priceLabel
    }

    private func generateCustomCellDiscountedLabel(product: Product, discountedPriceLabel: UILabel) -> UILabel {
        if let discountedPrice = product.discountedPrice {
            discountedPriceLabel.text = "\(product.currency)\(discountedPrice)"
            discountedPriceLabel.textColor = .lightGray
        } else {
            discountedPriceLabel.text = ""
        }
        return discountedPriceLabel
    }
    
    private func generateCustomCellStockLabel(product: Product, stockLabel: UILabel) -> UILabel {
        if product.stock == .zero {
            stockLabel.text = "품절"
            stockLabel.textColor = .orange
        } else {
            let enoughCount = 9999
            let leftover = product.stock > enoughCount ? "재고 많음" : "\(product.stock)"
            stockLabel.text = "잔여수량 : \(leftover)"
            stockLabel.textColor = .lightGray
        }
        return stockLabel
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
        
        let cellProduct = productList[indexPath.row]
        
        let stockLabel = generateCustomCellStockLabel(product: cellProduct, stockLabel: cell.stockLabel)
        let priceLabel = generateCustomCellPriceLabel(product: cellProduct, priceLabel: cell.priceLabel)
        let discountedPriceLabel = generateCustomCellDiscountedLabel(product: cellProduct, discountedPriceLabel: cell.discountedPriceLabel)
        let titleLabel = generateCostomCellTitleLabel(product: cellProduct, titleLabel: cell.titleLabel)
        
        cell.updateLabels(title: titleLabel, price: priceLabel, discountdPrice: discountedPriceLabel, stock: stockLabel)
        cell.loadThumbnails(product: cellProduct) { (image) in
            cell.thumbnailImage.image = image
        }
        
        return cell
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 10, height: collectionView.frame.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        return inset
    }
}


