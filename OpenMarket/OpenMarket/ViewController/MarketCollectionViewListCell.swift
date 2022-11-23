//
//  MarketCollectionViewListCell.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/22.
//

import UIKit

class MarketCollectionViewListCell: UICollectionViewListCell {
    var pageData: Page?
    lazy var pageListContentView = UIListContentView(configuration: configureListCell())
    var stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    var stockLabelConstraints: (leading: NSLayoutConstraint, trailing: NSLayoutConstraint)?
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.pageData = self.pageData
        return state
    }
    
    func configureListCell() -> UIListContentConfiguration {
        return .subtitleCell()
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()
        
        var content = configureListCell().updated(for: state)
        
        if let thumbnail = state.pageData?.thumbnail {
            content.image = urlToImage(thumbnail)
        }
        
        guard let pageData = state.pageData else { return }
        
        content.imageProperties.maximumSize = CGSize(width: 80, height: 80)
        content.imageProperties.cornerRadius = 10
        content.text = pageData.name
        content.textProperties.font = .preferredFont(forTextStyle: .title2)
        content.secondaryTextProperties.color = .systemGray
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
        
        if pageData.bargainPrice > 0  {
            content.secondaryAttributedText = NSMutableAttributedString()
                .strikethrough(string: "\(pageData.currency.rawValue) \(pageData.price)")
                .normal(string: "\n\(pageData.currency.rawValue) \(pageData.bargainPrice)")
        } else {
            content.secondaryAttributedText = NSMutableAttributedString()
                .normal(string: "\(pageData.currency.rawValue) \(pageData.price)")
        }
        
        if pageData.stock == 0 {
            stockLabel.attributedText = NSMutableAttributedString()
                .orangeColor(string: "품절")
        } else {
            stockLabel.attributedText = NSMutableAttributedString()
                .normal(string: "잔여수량: \(pageData.stock)")
        }
        pageListContentView.configuration = content
    }
    
    func urlToImage(_ urlString: String) -> UIImage? {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
                  return nil
              }

        return image
    }
    
    func update(with newPageData: Page) {
        guard pageData != newPageData else { return }
        pageData = newPageData
        setNeedsUpdateConfiguration()
    }
}

extension UIConfigurationStateCustomKey {
    static let page = UIConfigurationStateCustomKey("page")
}

extension UIConfigurationState {
    var pageData: Page? {
        get { return self[.page] as? Page }
        set { self[.page] = newValue }
    }
}

extension MarketCollectionViewListCell {
    func setupViewsIfNeeded() {
        guard stockLabelConstraints == nil else { return }
        
        [pageListContentView, stockLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let labelConstraints = (leading:
                                    stockLabel.leadingAnchor.constraint(
                                        greaterThanOrEqualTo:pageListContentView.trailingAnchor
                                    ),
                                trailing:
                                    stockLabel.trailingAnchor.constraint(
                                        equalTo: contentView.trailingAnchor
                                    ))
        
        NSLayoutConstraint.activate([
            pageListContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pageListContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            pageListContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pageListContentView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stockLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            labelConstraints.leading,
            labelConstraints.trailing
        ])
        
        stockLabelConstraints = labelConstraints
    }
}
