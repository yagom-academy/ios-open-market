//
//  ProductItemCell.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

// MARK: ProductItemCellContent Protocol
protocol ProductItemCellContent: AnyObject {
    var task: URLSessionDataTask? { get set }
    var activityIndicator: UIActivityIndicatorView { get }
    
    var thumbnailImageView: UIImageView { get set }
    var titleLabel: UILabel { get set }
    var subTitleLabel: UILabel { get set }
    var stockLabel: UILabel { get set }
    
    func configureLayout()
    func setupConstraints()
    func configureStyle()
    
    func setTitleLabel(productName: String)
    func setStockLabelValue(stock: Int)
    func setPriceLabel(originPrice: String, bargainPrice: String, segment: Int)
    func setImageTask(url: String)
    func setupCellData(product: Product, index: Int)
}

// MARK: Configure Item Data
extension ProductItemCellContent {
    func setStockLabelValue(stock: Int) {
        if stock <= 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
        } else {
            stockLabel.text = "잔여수량 : \(stock)"
            stockLabel.textColor = .secondaryLabel
        }
    }
    
    func setPriceLabel(originPrice: String, bargainPrice: String, segment: Int) {
        let bargainPriceString = (segment == 0 ? " \(bargainPrice)" : "\n\(bargainPrice)")
        
        if bargainPrice != originPrice {
            let text = originPrice + bargainPriceString
            subTitleLabel.attributedText = text.convertCancelLineString(target: originPrice)
        } else {
            subTitleLabel.text = originPrice
        }
    }
    
    func setTitleLabel(productName: String) {
        titleLabel.text = productName
    }
    
    func setupCellData(product: Product, index: Int) {
        configureStyle()
        configureLayout()
        setupConstraints()
        activityIndicator.startAnimating()
        
        setImageTask(url: product.thumbnail)
        setTitleLabel(productName: product.name)
        setStockLabelValue(stock: product.stock)
        setPriceLabel(
            originPrice: product.originPriceStringValue,
            bargainPrice: product.bargainPriceStringValue,
            segment: index
        )
    }
    
    func setImageTask(url: String) {
        guard let imageURL = URL(string: url) else {
            return
        }
        
        task = URLSession.createTask(url: imageURL) { image in
            DispatchQueue.main.async {
                self.thumbnailImageView.image = image
                self.activityIndicator.stopAnimating()
            }
        }
        
        task?.resume()
    }
}

// MARK: String +
private extension String {
    func convertCancelLineString(target: String) -> NSMutableAttributedString {
        let font = UIFont.preferredFont(forTextStyle: .subheadline)
        let range = (self as NSString).range(of: target)
        let attributeString = NSMutableAttributedString(string: self)
        
        attributeString.addAttribute(.strikethroughColor, value: UIColor.red, range: range)
        attributeString.addAttribute(.strikethroughStyle, value: 1, range: range)
        attributeString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        attributeString.addAttribute(.font, value: font, range: range)
        
        return attributeString
    }
}

// MARK: URLSession +
extension URLSession {
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
