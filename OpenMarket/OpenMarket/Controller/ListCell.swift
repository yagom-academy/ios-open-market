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

class ListCell: UICollectionViewCell {
    private lazy var cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "flame")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
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
        return label
    }()
    
    private lazy var bargenLabel: UILabel = {
        let label = UILabel()
        label.text = "Bargen Label"
        return label
    }()
    
    private lazy var stockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var stockLabel: UILabel = {
        let label = UILabel()
        label.text = "Stock Label"
        return label
    }()
    
    private lazy var accessoryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addsubViews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - layout

extension ListCell {
    private func addsubViews() {
        self.contentView.addSubview(cellStackView)
        self.cellStackView.addArrangedsubViews(thumbnailImageView, informationStackView, stockStackView)
        self.informationStackView.addArrangedsubViews(nameLabel, priceStackView)
        self.priceStackView.addArrangedsubViews(priceLabel, bargenLabel)
        self.stockStackView.addArrangedsubViews(stockLabel, accessoryImage)
    }
    
    private func layout() {
        
        
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalToConstant: frame.height * 4 / 5),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: frame.height * 4 / 5),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: informationStackView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            informationStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            informationStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            informationStackView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -100)
        ])
        
        NSLayoutConstraint.activate([
            stockStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stockStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),
            stockStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
