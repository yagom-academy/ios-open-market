//
//  DetailView.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/12/07.
//

import UIKit

final class DetailView: UIView {
    private let rightButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "square.and.arrow.up")
        return barButton
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageCollectionView,
                                                       imageNumberLabel,
                                                       informationStackView,
                                                       descriptionTextView])
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let imageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let imageNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var informationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, stockLabel, priceLabel])
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.adjustsFontForContentSizeCategory = true
        return textView
    }()
    
    private func configureView() {
        scrollView.addSubview(stackView)
        addSubview(scrollView)
    }
    
    func fetchNavigationBarButton() -> UIBarButtonItem {
        return rightButton
    }
    
    func configureStockLabel(from text: String) {
        if text == "품절" {
            stockLabel.textColor = .systemOrange
        } else {
            stockLabel.textColor = .systemGray
        }
        stockLabel.text = text
    }
    
    func configurePriceLabel(from text: NSMutableAttributedString) {
        priceLabel.attributedText = text
    }
    
    func configuredescriptionText(from text: String) {
        descriptionTextView.text = text
    }
}
