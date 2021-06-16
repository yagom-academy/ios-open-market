//
//  CollectionViewCellForList.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/11.
//

import UIKit

class CollectionViewCellForList: GeneratedCollectionViewCell {
    static let identifier = "listCell"

    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.backgroundColor = .white
        stackView.spacing = 5

        return stackView
    }()

    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.backgroundColor = .white
        stackView.spacing = 5

        return stackView
    }()
    
    let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.backgroundColor = .white
        stackView.spacing = 5

        return stackView
    }()

    let chevronButton: UIButton = {
        var button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .systemGray2
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mainStackView)

        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(contentsStackView)
        mainStackView.addArrangedSubview(stockLabel)
        mainStackView.addArrangedSubview(chevronButton)

        contentsStackView.addArrangedSubview(productLabel)
        contentsStackView.addArrangedSubview(priceStackView)

        priceStackView.addArrangedSubview(originalPriceLabel)
        priceStackView.addArrangedSubview(discountedPriceLabel)

        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),

            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.18),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
