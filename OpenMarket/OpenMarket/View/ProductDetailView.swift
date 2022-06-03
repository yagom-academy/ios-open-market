//
//  ProductDetailView.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/06/02.
//

import UIKit

final class ProductDetailView: UIView {
    lazy var entireStackView = makeStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 20)
    lazy var priceStackView = makeStackView(axis: .vertical, alignment: .trailing, distribution: .fill, spacing: 3)
    lazy var productInfoStackView = makeStackView(axis: .horizontal, alignment: .top, distribution: .fillProportionally, spacing: 0)
    
    private let entireScrollView = UIScrollView()
    private let productImage = UIImageView()
    let stockLabel = UILabel()
    let priceLabel = UILabel()
    let discountedLabel = UILabel()
    let productNameLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let currencyLabel = UILabel()
    let pageControl = UIPageControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configurePageControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDetailView(_ presenter: Presenter) {
        setStock(presenter)
        setDescription(presenter)
        setProductName(presenter)
        setPageControl(presenter)
    }
        
    private func configurePageControl() {
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
    }
}

extension ProductDetailView {
    private func configureView() {
        self.addSubview(entireScrollView)
        entireScrollView.addSubview(entireStackView)
        entireStackView.addArrangedSubview([pageControl, productInfoStackView, descriptionTextView])
        productInfoStackView.addArrangedSubview([productNameLabel, priceStackView])
        priceStackView.addArrangedSubview([stockLabel, currencyLabel, priceLabel, discountedLabel])
        
        configureLayout()
    }
    
    private func configureLayout() {
        entireScrollView.translatesAutoresizingMaskIntoConstraints = false
        entireStackView.translatesAutoresizingMaskIntoConstraints = false
        productInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productInfoStackView.topAnchor.constraint(equalTo: pageControl.bottomAnchor),
            productNameLabel.widthAnchor.constraint(equalTo: productInfoStackView.widthAnchor, multiplier: 0.6),
            priceStackView.widthAnchor.constraint(equalTo: productInfoStackView.widthAnchor, multiplier: 0.4)
        ])
        
        NSLayoutConstraint.activate([
            entireScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            entireScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            entireScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            entireScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.entireStackView.leadingAnchor.constraint(equalTo: entireScrollView.leadingAnchor),
            self.entireStackView.topAnchor.constraint(equalTo: entireScrollView.topAnchor),
            self.entireStackView.trailingAnchor.constraint(equalTo: entireScrollView.trailingAnchor),
            self.entireStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.entireStackView.widthAnchor.constraint(equalTo: entireScrollView.frameLayoutGuide.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: entireStackView.leadingAnchor),
            pageControl.topAnchor.constraint(equalTo: entireStackView.topAnchor),
            pageControl.trailingAnchor.constraint(equalTo: entireStackView.trailingAnchor)
        ])
    }
}

extension ProductDetailView {
    private func setProductName(_ presenter: Presenter) {
        productNameLabel.text = presenter.productName
        productNameLabel.numberOfLines = 0
    }
    
    private func setStock(_ presenter: Presenter) {
        guard let stock = presenter.stock else { return }
        
        stockLabel.text = "남은 수량 : \(stock)"
        stockLabel.numberOfLines = 0
    }
    
    private func setDescription(_ presenter: Presenter) {
        descriptionTextView.text = presenter.description
    }
    
    private func setPageControl(_ presenter: Presenter) {
        pageControl.numberOfPages = presenter.images?.count ?? 0
    }
}

private extension ProductDetailView {
    func makeStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        
        return stackView
    }
}
