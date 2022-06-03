//
//  DetailView.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/31.
//

import UIKit

final class DetailView: UIView {
    
    private let imageCache = ImageCache.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var baseScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mainVerticalStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
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
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [])
        view.axis = .horizontal
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [])
        view.axis = .vertical
        return view
    }()
    
    private lazy var stockLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var discountPriceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private func setUpConstraints() {
        
        self.addSubview(baseScrollView)
        NSLayoutConstraint.activate([
            baseScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            baseScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            baseScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            baseScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            baseScrollView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
        
        baseScrollView.addSubview(imageScrollView)
        NSLayoutConstraint.activate([
            imageScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageScrollView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
        ])
        
        imageScrollView.addSubview(imageContentStackView)
        NSLayoutConstraint.activate([
            imageContentStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageContentStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
            imageContentStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            imageContentStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor)
        ])
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
    
    func setUpView(productDetail: ProductDetail) {
        let images = productDetail.images
        for productImage in images {
            let urlString = productImage.url
            imageCache.loadImage(urlString: urlString) { image in
                DispatchQueue.main.async { [weak self] in
                    guard let image = image, let self = self else {
                        return
                    }
                    self.generateImageView(image: image)
                }
            }
        }
    }
}
