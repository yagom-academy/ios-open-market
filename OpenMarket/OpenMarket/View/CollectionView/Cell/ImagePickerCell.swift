//
//  ImagePickerCell.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/30.
//

import UIKit

final class ImagePickerCell: UICollectionViewCell {
    //MARK: - Views
    private let contentStackView: UIStackView = {
        let stackView: UIStackView = .init()
        
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    var content: UIView? {
        return contentStackView.subviews.first
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Method
    func addContentView(_ newView: UIView) {
        contentStackView.addArrangedSubview(newView)
    }
    
    private func configure() {
        setUpViewsIfNeeded()
    }

    private func setUpViewsIfNeeded() {
        contentView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentStackView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
