//  Created by Aejong, Tottale on 2022/12/02.

import UIKit

class ProductAddView: UIView {
    
    let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let productNameTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        textField.placeholder = "상품명"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6
        textField.addLeftPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let productPriceTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        textField.placeholder = "상품가격"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6
        textField.addLeftPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let productBargainPriceTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        textField.placeholder = "할인금액"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6
        textField.addLeftPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let productStockTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        self.textFieldStackView.addArrangedSubview(productNameTextField)
        self.textFieldStackView.addArrangedSubview(productPriceTextField)
        self.textFieldStackView.addArrangedSubview(productBargainPriceTextField)
        self.textFieldStackView.addArrangedSubview(productStockTextField)
        self.addSubview(textFieldStackView)
    }
    
    private func configureStackView() {
        NSLayoutConstraint.activate([
            self.textFieldStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.textFieldStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.textFieldStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.textFieldStackView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}
