//  Created by Aejong, Tottale on 2022/12/02.

import UIKit

class ProductManageView: UIView {
    
    let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6
        textField.addLeftPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let productPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let productPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6
        textField.addLeftPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let productPriceSegment: UISegmentedControl = {
        let segmentTextContent = ["KRW", "USD"]
        let segmentedControl = UISegmentedControl(items: segmentTextContent)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    let productBargainPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인금액"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6
        textField.addLeftPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let productStockTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6
        textField.addLeftPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let photoAddButton: UIButton = {
        let button = ImageAddButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configureViews()
        configureStackView()
        configureImageScrollView()
        configureTextView()
        self.imageStackView.addArrangedSubview(self.photoAddButton)
        configureAddButton()
    }
    
    required init(product: Product, images: [UIImage]) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        configureViews()
        configureStackView()
        configureImageScrollView()
        configureTextView()
        configureData(product: product)
        configureImage(images: images)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureData(product: Product) {
        self.productNameTextField.text = product.name
        self.productPriceSegment.selectedSegmentIndex = product.currency == "KRW" ? 0 : 1
        self.productPriceTextField.text = product.price.decimalInt
        self.productBargainPriceTextField.text = product.discountedPrice.decimalInt
        self.productStockTextField.text = product.stock.description
    }
    
    private func configureImage(images: [UIImage]) {
        images.forEach { image in
            let imageView = UIImageView()
            imageView.image = image
            self.imageStackView.addArrangedSubview(imageView)
            self.imageStackView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        }
    }
    
    private func configureViews() {
        self.productPriceStackView.addArrangedSubview(productPriceTextField)
        self.productPriceStackView.addArrangedSubview(productPriceSegment)
        self.textFieldStackView.addArrangedSubview(productNameTextField)
        self.textFieldStackView.addArrangedSubview(productPriceStackView)
        self.textFieldStackView.addArrangedSubview(productBargainPriceTextField)
        self.textFieldStackView.addArrangedSubview(productStockTextField)
        self.imageScrollView.addSubview(imageStackView)
        self.addSubview(textFieldStackView)
        self.addSubview(imageScrollView)
        self.addSubview(descriptionTextView)
    }
    
    private func configureImageScrollView() {
        NSLayoutConstraint.activate([
            self.imageScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.imageScrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.imageScrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.imageScrollView.heightAnchor.constraint(equalTo: self.textFieldStackView.heightAnchor, multiplier: 1)
        ])
        
        let bottom = self.imageScrollView.bottomAnchor.constraint(lessThanOrEqualTo: self.textFieldStackView.topAnchor, constant: -10)
        bottom.priority = .defaultLow
        bottom.isActive = true
        
        NSLayoutConstraint.activate([
            self.imageStackView.topAnchor.constraint(equalTo: self.imageScrollView.topAnchor),
            self.imageStackView.leadingAnchor.constraint(equalTo: self.imageScrollView.leadingAnchor),
            self.imageStackView.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor),
            self.imageStackView.bottomAnchor.constraint(equalTo: self.imageScrollView.bottomAnchor),
            self.imageStackView.heightAnchor.constraint(equalTo: self.imageScrollView.heightAnchor, multiplier: 1)
        ])
    }
    
    private func configureStackView() {
        NSLayoutConstraint.activate([
            self.productPriceTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            self.textFieldStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.textFieldStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            self.textFieldStackView.heightAnchor.constraint(equalTo: self.descriptionTextView.heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func configureTextView() {
        NSLayoutConstraint.activate([
            self.descriptionTextView.topAnchor.constraint(equalTo: self.textFieldStackView.bottomAnchor, constant: 10),
            self.descriptionTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.descriptionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            self.descriptionTextView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func configureAddButton() {
        NSLayoutConstraint.activate([
            self.photoAddButton.widthAnchor.constraint(equalTo: self.imageStackView.heightAnchor, multiplier: 1)
        ])
    }
    
    func addImageView(with image: UIImage) {
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageStackView.insertArrangedSubview(imageView, at: self.imageStackView.subviews.count - 1)
        updateScrollViewToRight()
    }
    
    func updateScrollViewToRight() {
        imageScrollView.layoutIfNeeded()
        imageScrollView.setContentOffset(
            CGPoint(x: imageScrollView.contentSize.width - imageScrollView.bounds.width,
                    y: 0),
            animated: true)
    }
}
