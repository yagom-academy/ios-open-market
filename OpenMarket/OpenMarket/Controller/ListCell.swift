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
    private lazy var cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "flame")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false

        return image
    }()
    
    private lazy var informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 7
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name Label"
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Price Label"
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var bargenLabel: UILabel = {
        let label = UILabel()
        label.text = "Bargen Label"
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var stockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var stockLabel: UILabel = {
        let label = UILabel()
        label.text = "Stock Label"
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    private lazy var accessoryLabel: UILabel = {
        let label = UILabel()
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "chevron.right")?.withTintColor(.lightGray)
        let attachmentString = NSAttributedString(attachment: attachment)
        let attributedStr = NSMutableAttributedString(string: attachmentString.description)
        label.attributedText = attachmentString
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addsubViews()
        layout()
        setupBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBorder() {
        let border = layer.addBorder(edges: [.bottom], color: .lightGray, thickness: 0.5, bottomLeftSpacing: 15)
        layer.addSublayer(border)
    }
    
    func update(data: Product) {
        nameLabel.text = data.name
        
        if data.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
        } else {
            guard let stock = data.stock else {
                return
            }
            stockLabel.text = "재고수량: \(stock)"
        }
        
        guard let currency = data.currency else {
            return
        }
                
        let price = Formatter.convertNumber(by: data.price?.description)
        let bargenPrice = Formatter.convertNumber(by: data.bargainPrice?.description)
        
        if data.discountedPrice == 0 {
            priceLabel.text = "\(currency)\(price)"
            bargenLabel.text = ""
        } else {
            priceLabel.textColor = .systemRed
            priceLabel.attributedText = "\(currency)\(price) ".strikeThrough()
            
            bargenLabel.text = "\(currency)\(bargenPrice)"
        }
    }
    
    func update(image: UIImage) {
        DispatchQueue.main.async {
            self.thumbnailImageView.image = image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        priceLabel.attributedText = nil
        bargenLabel.text = nil
        priceLabel.text = nil
        priceLabel.attributedText = nil
        priceLabel.textColor = .lightGray
        stockLabel.textColor = .lightGray
    }
}

// MARK: - layout

extension ListCell {
    private func addsubViews() {
        contentView.addSubview(cellStackView)
        cellStackView.addArrangedsubViews(thumbnailImageView, informationStackView, stockStackView)
        informationStackView.addArrangedsubViews(nameLabel, priceStackView)
        priceStackView.addArrangedsubViews(priceLabel, bargenLabel)
        stockStackView.addArrangedsubViews(stockLabel, accessoryLabel)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalTo: cellStackView.heightAnchor, constant: -5),
            thumbnailImageView.heightAnchor.constraint(equalTo: cellStackView.heightAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            informationStackView.widthAnchor.constraint(equalTo: cellStackView.widthAnchor, multiplier: 0.5)
        ])
    }
}
