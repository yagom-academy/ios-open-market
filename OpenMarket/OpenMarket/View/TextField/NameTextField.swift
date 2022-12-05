//
//  NameTextField.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/29.
//

import UIKit

final class NameTextField: UITextField {
    private let countLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/100"
        label.textColor = .systemGray5
        label.font = UIFont.systemFont(ofSize: 10)
        
        return label
    }()
    private let productNamePlaceholder: String = "상품명"
    private var minimumLength: Int
    private var maximumLength: Int
    var hasEnoughText: Bool {
        get {
            return minimumLength <= text?.count ?? 0
        }
    }
    
    init(minimumLength: Int = 0, maximumLength: Int = 1000) {
        self.minimumLength = minimumLength
        self.maximumLength = maximumLength
        super.init(frame: .zero)

        configure()
        setUpCountLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .white
        font = .preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = true
        placeholder = productNamePlaceholder
        keyboardType = .default
        borderStyle = .roundedRect
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    private func setUpCountLabel() {
        addSubview(countLabel)
        NSLayoutConstraint.activate([
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            countLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func checkEnoughText() {
        if hasEnoughText {
            layer.borderColor = UIColor.systemBlue.cgColor
            countLabel.textColor = .systemBlue
        } else {
            layer.borderColor = UIColor.red.cgColor
            countLabel.textColor = .red
        }
        countLabel.text = "\(text?.count ?? 0) / \(maximumLength)"
    }
    
    func isLessThanOrEqualMaximumLength(_ length: Int) -> Bool {
        if length <= maximumLength {
            return true
        } else {
            return false
        }
    }
}
