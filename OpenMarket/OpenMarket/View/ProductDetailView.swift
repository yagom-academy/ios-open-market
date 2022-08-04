//
//  ProductSetupView.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/08/04.
//

import UIKit

final class ProductDetailView: UIView {
    // MARK: - UI Components Frame
    let mainScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var mainStackView: UIStackView = {
        var stackview = UIStackView(arrangedSubviews: [horizontalScrollView,
                                                       pagingLabel,
                                                       upperStackView,
                                                       lowerStackView,
                                                       descriptionTextView])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .fill
        stackview.spacing = 10
        return stackview
    }()
    
    let horizontalScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    lazy var horizontalStackView: UIStackView = {
        var stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.distribution = .equalSpacing
        stackview.alignment = .fill
        return stackview
    }()
    
    let pagingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let upperStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    let stockLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let lowerStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let bargainPriceLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    
    lazy var descriptionTextView: UITextView = {
        var textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.isScrollEnabled = false
        textview.text = "여기에 내용을 입력해주세요."
        return textview
    }()
    
    
    // MARK: - View Initializer
    init(_ rootViewController: UIViewController) {
        super.init(frame: .null)
        addSubViews(rootViewController)
        setupConstraints(rootViewController)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews(_ rootViewController: UIViewController) {
        rootViewController.view.addSubview(mainScrollView)
        mainScrollView.addSubview(mainStackView)
        horizontalScrollView.addSubview(horizontalStackView)
        
        upperStackView.addArrangedSubview(productNameLabel)
        upperStackView.addArrangedSubview(stockLabel)
        
        lowerStackView.addArrangedSubview(priceLabel)
        lowerStackView.addArrangedSubview(bargainPriceLabel)
    }
    
    private func setupConstraints(_ rootViewController: UIViewController) {
        let mainStackViewHeightAnchor = mainStackView.heightAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.heightAnchor)
        mainStackViewHeightAnchor.priority = UILayoutPriority(rawValue: UILayoutPriority.defaultLow.rawValue)
        
        let horizontalStackViewWidthAnchor = horizontalStackView.widthAnchor.constraint(equalTo: horizontalScrollView.frameLayoutGuide.widthAnchor)
        horizontalStackViewWidthAnchor.priority = UILayoutPriority(rawValue: UILayoutPriority.defaultLow.rawValue)
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: rootViewController.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor),
            mainStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            horizontalStackViewWidthAnchor,
            horizontalStackView.topAnchor.constraint(equalTo: horizontalScrollView.contentLayoutGuide.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: horizontalScrollView.contentLayoutGuide.bottomAnchor),
            horizontalStackView.heightAnchor.constraint(equalTo: horizontalScrollView.heightAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: horizontalScrollView.contentLayoutGuide.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: horizontalScrollView.contentLayoutGuide.trailingAnchor)
        ])
//        NSLayoutConstraint.activate([
//            horizontalScrollView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
//            horizontalScrollView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
//            horizontalScrollView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
//        ])
        
        
    }
}
