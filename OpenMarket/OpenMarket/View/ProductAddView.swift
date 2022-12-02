//  Created by Aejong, Tottale on 2022/12/02.

import UIKit

class ProductAddView: UIView {
    
    let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.semanticContentAttribute = .forceRightToLeft
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configureViews()
        configureStackView()
        configureImageScrollView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
    
    private func configureImageScrollView() {
        NSLayoutConstraint.activate([
            self.imageScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.imageScrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.imageScrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.imageScrollView.bottomAnchor.constraint(equalTo: self.textFieldStackView.topAnchor)
        ])
        
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
            self.textFieldStackView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}
