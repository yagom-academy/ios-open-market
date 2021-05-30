//
//  ItemContentView.swift
//  OpenMarket
//
//  Created by 윤재웅 on 2021/05/26.
//

import UIKit

@available(iOS 14.0, *)
class ItemContentView: UIView, UIContentView {
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var ItemImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var stock: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    
    private var currentConfiguration: ItemConfiguration!
    var configuration: UIContentConfiguration {
        get {
            return currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? ItemConfiguration else { return }
            apply(newConfiguration)
        }
    }
    
    init(configuration: ItemConfiguration) {
        super.init(frame: .zero)
        loadNib()
        apply(configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@available(iOS 14.0, *)
extension ItemContentView {
    private func loadNib() {
        Bundle.main.loadNibNamed("\(ItemContentView.self)", owner: self, options: nil)
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
        ])
    }
    
    private func apply(_ configuration: ItemConfiguration) {
        guard currentConfiguration != configuration else { return }
        currentConfiguration = configuration
        fetchImage(configuration)
        cancelTextLine(configuration)
        setSoldOutText(configuration)
        self.title.text = configuration.title
    }

    private func cancelTextLine(_ configuration: ItemConfiguration) {
        resetPrice()
        guard let price = configuration.price, let currency = configuration.currency else { return }
        if let discountPrice = configuration.discountPrice {
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: String("\(configuration.currency!) \(price)"))
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            self.price.text = String("\(currency) \(price)")
            self.price.textColor = .red
            self.price.attributedText = attributeString
            self.discountPrice.isHidden = false
            self.discountPrice.text = "\(currency) " + String(discountPrice)
        } else {
            self.price.text = String("\(currency) \(price)")
            self.discountPrice.isHidden = true
        }
    }
    
    private func setSoldOutText(_ configuration: ItemConfiguration) {
        guard let stock = configuration.stock else { return }
        resetStock()
        if stock == 0 {
            self.stock.textColor = .systemOrange
            self.stock.text = String("품절")
        } else {
            self.stock.text = String("재고 : \(stock)")
        }
    }
    
    private func resetPrice() {
        self.price.textColor = .systemGray
        self.price.attributedText = nil
    }
    
    private func resetStock() {
        self.stock.textColor = .systemGray
    }
    
    private func fetchImage(_ configuration: ItemConfiguration)   {
        self.ItemImageView.image = nil
        guard let image = configuration.image, let firstImage = image.first else { return }
        guard let url = URL(string: firstImage) else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.ItemImageView.image = UIImage(data: data) ?? UIImage()
            }
        }
    }
}
