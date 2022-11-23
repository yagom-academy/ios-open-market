//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by 스톤, 로빈 on 2022/11/21.
//

import UIKit

extension UIConfigurationStateCustomKey {
    static let item = UIConfigurationStateCustomKey("item")
}

extension UICellConfigurationState {
    var item: Item? {
        set { self[.item] = newValue }
        get { return self[.item] as? Item }
    }
}

final class ListCollectionViewCell: UICollectionViewListCell {
    private var item: Item?
    
    private func defaultListContentConfiguration() -> UIListContentConfiguration {
        return .subtitleCell()
    }
    
    private lazy var itemListContentView = UIListContentView(configuration: defaultListContentConfiguration())
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = .systemGray
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var stockConstraints: (leading: NSLayoutConstraint, trailing: NSLayoutConstraint,
                                   width: NSLayoutConstraint, centerY: NSLayoutConstraint)?
    
    
    func updateWithItem(_ newItem: Item) {
        guard item != newItem else { return }
        item = newItem
        setNeedsUpdateConfiguration()
    }
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.item = self.item
        return state
    }
}

extension ListCollectionViewCell {
    private func setupViewsIfNeeded() {
        guard stockConstraints == nil else { return }
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.itemListContentView)
        self.contentView.addSubview(self.stockLabel)
        self.itemListContentView.translatesAutoresizingMaskIntoConstraints = false
        self.stockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = (leading:
                            self.stockLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.itemListContentView.trailingAnchor),
                           trailing: self.stockLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
                           width: self.stockLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.3),
                           centerY: self.stockLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor))
        
        let imageViewHeight = self.imageView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.15)
        imageViewHeight.priority = UILayoutPriority(750)
        
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            self.imageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.15),
            imageViewHeight,

            self.itemListContentView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.itemListContentView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.itemListContentView.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor),
            self.itemListContentView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5),

            constraints.leading,
            constraints.trailing,
            constraints.width,
            constraints.centerY
        ])
        
        self.stockConstraints = constraints
    }
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()
        
        guard let url = URL(string: state.item?.thumbnail ?? "") else { return }
        
        var content = defaultListContentConfiguration().updated(for: state)
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        content.text = state.item?.name
        content.textProperties.font = .preferredFont(forTextStyle: .headline)

        guard let item = self.item else { return }
        let priceString = "\(item.currency.rawValue) \(item.price.formattedString) \(item.currency.rawValue) \(item.bargainPrice.formattedString)"
        let attributedString = NSMutableAttributedString(string: priceString)
        attributedString.addAttribute(.strikethroughStyle, value: 1,
                                      range: (priceString as NSString).range(of:"\(item.currency.rawValue) \(item.price.formattedString)"))
        attributedString.addAttribute(.foregroundColor, value: UIColor.red,
                                      range: (priceString as NSString).range(of:"\(item.currency.rawValue) \(item.price.formattedString)"))
        content.secondaryAttributedText = attributedString
        content.secondaryTextProperties.color = .systemGray
        
        itemListContentView.configuration = content
        
        if item.stock == 0 {
            self.stockLabel.textColor = .systemOrange
            self.stockLabel.text = "품절"
            self.stockLabel.textAlignment = .right
        } else {
            self.stockLabel.textColor = .systemGray
            self.stockLabel.text = "잔여수량 : \(item.stock)"
            self.stockLabel.textAlignment = .left
        }
        NetworkManager().fetchImage(url: url) { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
}
