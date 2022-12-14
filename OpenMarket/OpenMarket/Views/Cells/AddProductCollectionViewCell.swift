//
//  AddProductCollectionViewCell.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/12/01.
//

import UIKit

protocol ImageCollectionViewCellDelegate: AnyObject {
    func imageCollectionViewCell(_ isShowPicker: Bool)
}

final class AddProductCollectionViewCell: UICollectionViewCell {
    weak var buttonDelegate: ImageCollectionViewCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func createButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .systemGray5
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        return button
    }
    
    func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }

    override func prepareForReuse() {
        self.stackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
    }
}

// MARK: - Action
extension AddProductCollectionViewCell {
    @objc func addImageButtonTapped() {
        buttonDelegate?.imageCollectionViewCell(true)
    }
}

// MARK: - Constraints
extension AddProductCollectionViewCell {
    private func setupUI() {
        contentView.addSubview(stackView)
        setupStackViewConstraints()
    }
    
    private func setupStackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

extension AddProductCollectionViewCell: ReuseIdentifierProtocol {
    
}
