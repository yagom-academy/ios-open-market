//
//  DetailView.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/31.
//

import UIKit

final class DetailView: UIView {
    
    private let imageCache = ImageCache.shared
    
    private enum Constant {
        static let spaceFromPagingLabelBottom: CGFloat = 15
        static let leftInsetFromSuperView: CGFloat = 10
        static let rightInsetFromSuperView: CGFloat = -10
        static let spaceFromVerticalStackViewBottom: CGFloat = 20
        static let stockLabelPrefix = "남은 수량 : "
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        imageScrollView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpConstraints()
    }
    
    private lazy var baseScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isPagingEnabled = true
        return view
    }()
    
    private lazy var imageContentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var pagingLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [stockLabel,
                                                  priceLabel,
                                                  discountPriceLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    private lazy var stockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .red
        return label
    }()
    
    private lazy var discountPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
}

// MARK: - Method

extension DetailView {
    
    private func setUpConstraints() {
        let contentLayoutGuide = baseScrollView.contentLayoutGuide
        
        self.addSubview(baseScrollView)
        NSLayoutConstraint.activate([
            baseScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            baseScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            baseScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            baseScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        baseScrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            baseScrollView.contentLayoutGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            baseScrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            baseScrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            baseScrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        contentView.addSubview(imageScrollView)
        NSLayoutConstraint.activate([
            imageScrollView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            imageScrollView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            imageScrollView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
        ])
        
        imageScrollView.addSubview(imageContentStackView)
        NSLayoutConstraint.activate([
            imageContentStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageContentStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
            imageContentStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            imageContentStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor)
        ])
        
        contentView.addSubview(pagingLabel)
        NSLayoutConstraint.activate([
            pagingLabel.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            pagingLabel.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            pagingLabel.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: 5)
        ])
        
        contentView.addSubview(productNameLabel)
        NSLayoutConstraint.activate([
            productNameLabel.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor,
                                                      constant: Constant.leftInsetFromSuperView),
            productNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentLayoutGuide.centerXAnchor),
            productNameLabel.topAnchor.constraint(equalTo: pagingLabel.bottomAnchor,
                                                  constant: Constant.spaceFromPagingLabelBottom),
        ])
        
        contentView.addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                        constant: Constant.rightInsetFromSuperView),
            verticalStackView.topAnchor.constraint(equalTo: productNameLabel.topAnchor),
            verticalStackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.centerXAnchor)
        ])
        
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor,
                                                  constant: Constant.spaceFromVerticalStackViewBottom),
            contentView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor)
        ])
    }
    
    private func updatePagingLabel(currentPage: Int) {
        let totalPages = imageContentStackView.subviews.count
        pagingLabel.text = "\(currentPage)/\(totalPages)"
    }
    
    private func generateImageView(image: UIImage) {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = image
        self.imageContentStackView.addArrangedSubview(view)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: self.widthAnchor),
            view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
        ])
    }
    
    private func setImage(images: [ProductImage]) {
        for productImage in images {
            let urlString = productImage.url
            imageCache.loadImage(urlString: urlString) { image in
                DispatchQueue.main.async { [weak self] in
                    guard let image = image, let self = self else {
                        return
                    }
                    self.generateImageView(image: image)
                    self.updatePagingLabel(currentPage: 1)
                }
            }
        }
    }
    
    func setUpView(productDetail: ProductDetail) {
        setImage(images: productDetail.images)
        productNameLabel.text = productDetail.name
        stockLabel.text = "\(Constant.stockLabelPrefix) \(productDetail.stock)"
        priceLabel.text = "\(productDetail.currency) \(productDetail.price)"
        discountPriceLabel.text = "\(productDetail.currency) \(productDetail.discountedPrice)"
        descriptionLabel.text = productDetail.description
    }
}

// MARK: - ScrollView Delegate

extension DetailView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        updatePagingLabel(currentPage: Int(round(value)) + 1)
    }
}
