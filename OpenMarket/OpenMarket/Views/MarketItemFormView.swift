//
//  MarketItemFormView.swift
//  OpenMarket
//
//  Created by yeha on 2022/01/27.
//

import UIKit

class MarketItemFormView: UIView {

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()

    let contentView: UIStackView = {
        let contentView = UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.distribution = .fill
        contentView.alignment = .fill
        contentView.spacing = 10
        contentView.backgroundColor = .systemBackground
        return contentView
    }()

    let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 130, height: 130)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.isDirectionalLockEnabled = true
        return collectionView
    }()

    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    }()

    let currencySegmentedControl: UISegmentedControl = {
        let items = [Currency.KRW.rawValue, Currency.USD.rawValue]
        let segmentedControl = UISegmentedControl(items: items)
        let selectedText = [NSAttributedString.Key.backgroundColor: UIColor.white]
        let defaultText = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.apportionsSegmentWidthsByContent = true
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(
            self,
            action: #selector(submitForm),
            for: .valueChanged
        )
        return segmentedControl
    }()

    let nameInputTextField: ItemInformationTextField = {
        let textField = ItemInformationTextField(type: .name)
        return textField
    }()

    let priceInputTextField: ItemInformationTextField = {
        let textField = ItemInformationTextField(type: .price)
        textField.keyboardType = .decimalPad
        textField.setContentCompressionResistancePriority(.required, for: .horizontal)
        return textField
    }()

    let discountedPriceInputTextField: ItemInformationTextField = {
        let textField = ItemInformationTextField(type: .discountedPrice)
        textField.keyboardType = .decimalPad
        return textField
    }()

    let stockInputTextField: ItemInformationTextField = {
        let textField = ItemInformationTextField(type: .stock)
        textField.keyboardType = .numberPad
        return textField
    }()

    let descriptionInputTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        return textView
    }()
}
