//
//  ProductsDetailView.swift
//  OpenMarket
//
//  Created by LeeChiheon on 2022/08/01.
//

import UIKit

class ProductsDetailView: UIView {

    // MARK: - Properties
    
    let itemImageView1: UIImageView = {
        let image = UIImage(systemName: "pencil")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    let itemImageView2: UIImageView = {
        let image = UIImage(systemName: "pencil")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    let itemImageView3: UIImageView = {
        let image = UIImage(systemName: "pencil")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    let itemImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    let itemImageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let currentPage: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "1/5"
        return label
    }()
    
    let itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = "상품 이름"
        return label
    }()
    
    let itemStockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        label.textColor = .systemGray
        label.text = "상품 재고"
        return label
    }()
    
    let itemNameAndStockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "상품 가격"
        return label
    }()
    
    let itemSaleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "상품 할인금액"
        return label
    }()
    
    let itemPriceAndSaleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fill
        return stackView
    }()
    
    let itemDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.text = """
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        테스트
                        """
        return textView
    }()
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func addSubviews() {
        addSubview(mainScrollView)
        
        mainScrollView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(itemImageScrollView)
        mainStackView.addArrangedSubview(currentPage)
        mainStackView.addArrangedSubview(itemNameAndStockStackView)
        mainStackView.addArrangedSubview(itemPriceAndSaleStackView)
        mainStackView.addArrangedSubview(itemDescriptionTextView)
        
        itemImageScrollView.addSubview(itemImageStackView)
        itemImageStackView.addArrangedSubview(itemImageView1)
        itemImageStackView.addArrangedSubview(itemImageView2)
        itemImageStackView.addArrangedSubview(itemImageView3)
        
        itemNameAndStockStackView.addArrangedSubview(itemNameLabel)
        itemNameAndStockStackView.addArrangedSubview(itemStockLabel)
        
        itemPriceAndSaleStackView.addArrangedSubview(itemPriceLabel)
        itemPriceAndSaleStackView.addArrangedSubview(itemSaleLabel)
    }
    
    func configureLayout() {
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            mainScrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            mainStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            itemImageScrollView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3)
        ])
        
        NSLayoutConstraint.activate([
            itemImageStackView.topAnchor.constraint(equalTo: itemImageScrollView.topAnchor),
            itemImageStackView.bottomAnchor.constraint(equalTo: itemImageScrollView.bottomAnchor),
            itemImageStackView.leadingAnchor.constraint(equalTo: itemImageScrollView.leadingAnchor),
            itemImageStackView.trailingAnchor.constraint(equalTo: itemImageScrollView.trailingAnchor),
            itemImageStackView.heightAnchor.constraint(equalTo: itemImageScrollView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            itemImageView1.heightAnchor.constraint(equalTo: itemImageView1.widthAnchor),
            itemImageView2.heightAnchor.constraint(equalTo: itemImageView2.widthAnchor),
            itemImageView3.heightAnchor.constraint(equalTo: itemImageView3.widthAnchor),
        ])
    }
    
}
