//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/12/07.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    private let detailProduct: DetailProduct
    private let detailView: DetailView = DetailView()

    override func loadView() {
        super.loadView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureDetailView()
    }
    
    init(_ detailProduct: DetailProduct) {
        self.detailProduct = detailProduct
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureNavigationBar() {
        navigationItem.title = detailProduct.name
        navigationItem.rightBarButtonItem = detailView.fetchNavigationBarButton()
    }
    
    private func configureDetailView() {
        detailView.configureStockLabel(from: setupStock())
        detailView.configurePriceLabel(from: setupPrice())
        detailView.configuredescriptionText(from: detailProduct.description)
    }
    
    private func setupStock() -> String {
        if detailProduct.stock.isZero {
            return "품절"
        } else if detailProduct.stock >= 1000 {
            let stock = FormatConverter.convertToDecimal(from: Double(detailProduct.stock / 1000))
            return "잔여수량 : \(stock.components(separatedBy: ".")[0])k"
        } else {
            return "잔여수량 : \(detailProduct.stock)"
        }
    }
    
    private func setupPrice() -> NSMutableAttributedString {
        let text: String
        let currency = detailProduct.currency.rawValue
        let price = FormatConverter.convertToDecimal(from: detailProduct.price)
        let bargainPrice = FormatConverter.convertToDecimal(from: detailProduct.bargainPrice)
        
        if detailProduct.discountedPrice.isZero {
            text = "\(currency) \(price)"
            let attributedString = NSMutableAttributedString(string: text)
            return attributedString
        } else {
            text = "\(currency) \(price)\n\(currency) \(bargainPrice)"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes([.foregroundColor: UIColor.systemRed, .strikethroughStyle: 1],
                                           range: (text as NSString).range(of: "\(currency) \(price)"))
            attributedString.addAttributes([.foregroundColor: UIColor.black],
                                           range: (text as NSString).range(of: "\(currency) \(bargainPrice)"))
            return attributedString
        }
    }
}
