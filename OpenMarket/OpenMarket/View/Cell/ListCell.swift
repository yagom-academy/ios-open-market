//
//  ListCell.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/17.
//

import UIKit

fileprivate enum Const {
    static let soldOut = "품절"
    static let stock = "재고수량"
    static let empty = ""
    static let indicator = "chevron.right"
}

final class ListCell: UICollectionViewCell, CustomCell {
    private let thumbnailImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .scaleAspectFit
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.textColor = .lightGray
        label.contentMode = .scaleAspectFit
        return label
    }()
    
    private let bargenLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.contentMode = .scaleAspectFit
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let accessoryLabel: UILabel = {
        let label = UILabel()
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: Const.indicator)?.withTintColor(.lightGray)
        let attachmentString = NSAttributedString(attachment: attachment)
        let attributedStr = NSMutableAttributedString(string: attachmentString.description)
        label.attributedText = attachmentString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBorder() {
        let border = layer.addBorder(edges: [.bottom], color: .lightGray, thickness: 0.5, bottomLeftSpacing: 15)
        layer.addSublayer(border)
    }
    
    func configure(data: DetailProduct) {
        loadImage(data: data)
        loadName(data: data)
        loadStock(data: data)
        loadPrice(data: data)
    }
    
    private func loadImage(data: DetailProduct) {
        
        guard let stringUrl = data.thumbnail else {
            return
        }
        
        guard let url = URL(string: stringUrl) else {
            return
        }
        
        thumbnailImageView.fetchImage(url: url) { image in
            DispatchQueue.main.async {
                self.thumbnailImageView.image = image
            }
        }
    }
    
    private func loadName(data: DetailProduct) {
        nameLabel.text = data.name
    }
    
    private func loadStock(data: DetailProduct) {
        
        if data.stock == 0 {
            stockLabel.text = Const.soldOut
            stockLabel.textColor = .systemYellow
        } else {
            guard let stock = data.stock else {
                return
            }
            stockLabel.text = "\(Const.stock): \(stock)"
        }
    }
    
    private func loadPrice(data: DetailProduct) {
        
        guard let currency = data.currency else {
            return
        }
        
        let price = Formatter.convertNumber(by: data.price?.description)
        let bargenPrice = Formatter.convertNumber(by: data.bargainPrice?.description)
        
        if data.discountedPrice == 0 {
            priceLabel.text = "\(currency) \(price)"
            bargenLabel.text = Const.empty
        } else {
            priceLabel.textColor = .systemRed
            priceLabel.attributedText = "\(currency) \(price) ".strikeThrough()
            
            bargenLabel.text = "\(currency) \(bargenPrice)"
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        priceLabel.attributedText = nil
        bargenLabel.text = nil
        priceLabel.text = nil
        priceLabel.textColor = .lightGray
        stockLabel.textColor = .lightGray
    }
}

// MARK: - Layout

extension ListCell {
    
    private func setupView() {
        
        addsubViews()
        constraintLayout()
        
        func addsubViews() {
            contentView.addsubViews(thumbnailImageView, nameLabel, priceStackView, stockLabel, accessoryLabel)
            priceStackView.addArrangedsubViews(priceLabel, bargenLabel)
         }
        
        func constraintLayout() {
            NSLayoutConstraint.activate([
                thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
                thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
           
                nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
                nameLabel.widthAnchor.constraint(equalToConstant: frame.width / 2),
                nameLabel.heightAnchor.constraint(equalToConstant: 20),
           
                priceStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
                priceStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                priceStackView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
                priceStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
                stockLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                stockLabel.bottomAnchor.constraint(equalTo: priceStackView.topAnchor, constant: -3),
                stockLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
                stockLabel.widthAnchor.constraint(equalToConstant: 100),
           
                accessoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                accessoryLabel.bottomAnchor.constraint(equalTo: priceStackView.topAnchor, constant: -3),
                accessoryLabel.leadingAnchor.constraint(equalTo: stockLabel.trailingAnchor, constant: 5),
                accessoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
                accessoryLabel.widthAnchor.constraint(equalToConstant: 15)
            ])
        }
        
    }
}
