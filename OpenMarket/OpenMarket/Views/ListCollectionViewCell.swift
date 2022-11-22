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
    func setupViewsIfNeeded() {
        guard stockConstraints == nil else { return }
        contentView.addSubview(imageView)
        contentView.addSubview(itemListContentView)
        contentView.addSubview(stockLabel)
        itemListContentView.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = (leading:
                            stockLabel.leadingAnchor.constraint(greaterThanOrEqualTo: itemListContentView.trailingAnchor),
                           trailing: stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
                           width: stockLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
                           centerY: stockLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor))
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.15),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.15),
            
            itemListContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemListContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            itemListContentView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
            itemListContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            
            constraints.leading,
            constraints.trailing,
            constraints.width,
            constraints.centerY
        ])
        
        stockConstraints = constraints
    }
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()
        
        guard let url = URL(string: state.item?.thumbnail ?? "") else { return }
        
        var content = defaultListContentConfiguration().updated(for: state)
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        content.text = state.item?.name
        content.textProperties.font = .preferredFont(forTextStyle: .headline)

        let priceString = "\(item!.currency.rawValue) \(item!.price) \(item!.currency.rawValue) \(item!.bargainPrice)"
        let attributedString = NSMutableAttributedString(string: priceString)
        attributedString.addAttribute(.strikethroughStyle, value: 1,
                                      range: (priceString as NSString).range(of:"\(item!.currency.rawValue) \(item!.price)"))
        attributedString.addAttribute(.foregroundColor, value: UIColor.red,
                                      range: (priceString as NSString).range(of:"\(item!.currency.rawValue) \(item!.price)"))
        content.secondaryAttributedText = attributedString
        content.secondaryTextProperties.color = .systemGray
        
        itemListContentView.configuration = content
        
        if state.item?.stock == 0 {
            self.stockLabel.textColor = .systemOrange
            self.stockLabel.text = "품절"
            self.stockLabel.textAlignment = .right
        } else {
            self.stockLabel.textColor = .systemGray
            self.stockLabel.text = "잔여수량 : \(state.item!.stock)"
        }
        NetworkManager().fetchImage(url: url) { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
}
