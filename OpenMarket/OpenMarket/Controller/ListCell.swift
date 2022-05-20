//
//  ListCell.swift
//  OpenMarket
//
//  Created by song on 2022/05/17.
//

import UIKit

extension ListCell {
    static var identifier: String {
        return String(describing: self)
    }
}

final class ListCell: UICollectionViewCell {
    
    private var thumbnailImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "flame")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name Label"
        label.contentMode = .scaleAspectFit
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Price Label"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.textColor = .lightGray
        label.contentMode = .scaleAspectFit

        return label
    }()
    
    private var bargenLabel: UILabel = {
        let label = UILabel()
        label.text = "Bargen Label"
        label.textColor = .lightGray
        label.contentMode = .scaleAspectFit

        return label
    }()
    
    private var stockLabel: UILabel = {
        let label = UILabel()
        label.text = "Stock Label"
        label.textColor = .lightGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private var accessoryLabel: UILabel = {
        let label = UILabel()
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "chevron.right")?.withTintColor(.lightGray)
        let attachmentString = NSAttributedString(attachment: attachment)
        let attributedStr = NSMutableAttributedString(string: attachmentString.description)
        label.attributedText = attachmentString
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addsubViews()
        constraintLayout()
        setupBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBorder() {
        let border = layer.addBorder(edges: [.bottom], color: .lightGray, thickness: 0.5, bottomLeftSpacing: 15)
        layer.addSublayer(border)
    }
    
    func configure(data: Product) {
        loadImage(data: data)
        loadName(data: data)
        loadStock(data: data)
        loadPrice(data: data)
    }
    
    private func loadImage(data: Product) {
        
        let url = URL(string: data.thumbnail!)!
        
        thumbnailImageView.fetchImage(url: url) { image in
            DispatchQueue.main.async {
                self.thumbnailImageView.image = image
            }
        }
    }
    
    private func loadName(data: Product) {
        nameLabel.text = data.name
    }
    
    private func loadStock(data: Product) {
        if data.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
        } else {
            guard let stock = data.stock else {
                return
            }
            stockLabel.text = "재고수량: \(stock)"
        }
    }
    
    private func loadPrice(data: Product) {
        guard let currency = data.currency else {
            return
        }
        
        let price = Formatter.convertNumber(by: data.price?.description)
        let bargenPrice = Formatter.convertNumber(by: data.bargainPrice?.description)
        
        if data.discountedPrice == 0 {
            priceLabel.text = "\(currency) \(price)"
            bargenLabel.text = ""
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

// MARK: - layout

extension ListCell {
    private func addsubViews() {
        contentView.addsubViews(thumbnailImageView, nameLabel, priceStackView, stockLabel, accessoryLabel)
        priceStackView.addArrangedsubViews(priceLabel, bargenLabel)
     }
    
    private func constraintLayout() {
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: frame.width / 2),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            priceStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            priceStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            priceStackView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            priceStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stockLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            stockLabel.bottomAnchor.constraint(equalTo: priceStackView.topAnchor, constant: -3),
            stockLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            stockLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            accessoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            accessoryLabel.bottomAnchor.constraint(equalTo: priceStackView.topAnchor, constant: -3),
            accessoryLabel.leadingAnchor.constraint(equalTo: stockLabel.trailingAnchor, constant: 5),
            accessoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            accessoryLabel.widthAnchor.constraint(equalToConstant: 10)
        ])
    }
}
