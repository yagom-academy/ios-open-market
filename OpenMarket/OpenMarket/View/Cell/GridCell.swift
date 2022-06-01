//
//  GridCell.swift
//  OpenMarket
//
//  Created by song on 2022/05/17.
//

import UIKit

fileprivate enum Const {
    static let soldOut = "품절"
    static let stock = "재고수량"
    static let empty = ""
}

final class GridCell: UICollectionViewCell, CustomCell {
    private let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let thumbnailImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .scaleAspectFit
        return label
    }()
    
    private let pricestackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    private let bargenLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBorder()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBorder() {
        let border = layer.addBorder(edges: [.all], color: .systemGray, thickness: 1.5, radius: 15)
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

extension GridCell {
    
    private func setupView() {
        
        addSubViews()
        constraintLayout()
        
        func addSubViews() {
            contentView.addsubViews(thumbnailImageView, cellStackView)
            cellStackView.addArrangedsubViews(informationStackView)
            informationStackView.addArrangedsubViews(nameLabel, pricestackView, stockLabel)
            pricestackView.addArrangedsubViews(priceLabel, bargenLabel)
        }
    
        func constraintLayout() {
            NSLayoutConstraint.activate([
                thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                thumbnailImageView.bottomAnchor.constraint(equalTo: cellStackView.topAnchor),
                thumbnailImageView.widthAnchor.constraint(equalToConstant: 150),
                thumbnailImageView.heightAnchor.constraint(equalToConstant: 150),
                thumbnailImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
                cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            ])
        }
    }
}
