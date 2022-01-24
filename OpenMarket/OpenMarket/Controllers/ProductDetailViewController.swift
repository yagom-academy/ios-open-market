//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by 이차민 on 2022/01/24.
//

import UIKit

class ProductDetailViewController: UIViewController {
    private let productDetailView = ProductDetailScrollView()
    private var productDetail: ProductDetail
    
    init(productDetail: ProductDetail) {
        self.productDetail = productDetail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("스토리보드 안써서 fatalError를 줬습니다.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        fetchProductDetail()
    }
    
    func configUI() {
        view.backgroundColor = .white
        self.view.addSubview(productDetailView)
        productDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productDetailView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            productDetailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            productDetailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            productDetailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func fetchProductDetail() {
        productDetailView.productNameLabel.text = productDetail.name
        productDetailView.productStockLabel.attributedText = AttributedTextCreator.createStockText(product: productDetail)
        
        guard let price = productDetail.price.formattedToDecimal,
              let bargainPrice = productDetail.bargainPrice.formattedToDecimal else {
            return
        }
        
        if productDetail.discountedPrice == 0 {
            productDetailView.productPriceLabel.isHidden = true
        } else {
            productDetailView.productPriceLabel.isHidden = false
            productDetailView.productPriceLabel.attributedText = NSMutableAttributedString.strikeThroughStyle(string: "\(productDetail.currency.unit) \(price)")
        }
        
        productDetailView.productBargainPriceLabel.attributedText = NSMutableAttributedString.normalStyle(string: "\(productDetail.currency.unit) \(bargainPrice)")
        productDetailView.productDescriptionTextView.text = productDetail.description
    }
}
