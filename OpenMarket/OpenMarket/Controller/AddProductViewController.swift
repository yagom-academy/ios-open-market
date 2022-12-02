//  Created by Aejong, Tottale on 2022/11/22.

import UIKit

final class AddProductViewController: UIViewController {
    
    let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
//        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let productNameTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        textField.placeholder = "상품명"
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.8
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let productPriceTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        textField.placeholder = "상품가격"
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.8
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let productBargainPriceTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        textField.placeholder = "할인금액"
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.8
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let productStockTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        textField.placeholder = "재고수량"
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.8
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        configureNavigationBar()
        configureDoneButton()
        configureCancelButton()
        configureViews()
        configureStackView()
    }
    
    private func configureViews() {
        self.textFieldStackView.addArrangedSubview(productNameTextField)
        self.textFieldStackView.addArrangedSubview(productPriceTextField)
        self.textFieldStackView.addArrangedSubview(productBargainPriceTextField)
        self.textFieldStackView.addArrangedSubview(productStockTextField)

        self.view.addSubview(textFieldStackView)
    }
    
    private func configureStackView() {
        NSLayoutConstraint.activate([
            self.textFieldStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.textFieldStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.textFieldStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.textFieldStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10)
        ])
    }
    
    private func configureNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.shadowColor = .clear
        self.navigationItem.title = "상품등록"
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func configureDoneButton() {
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                      action: nil)
        self.navigationItem.rightBarButtonItem = doneItem
    }
    
    private func configureCancelButton() {
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                                         action: #selector(cancelButtonPressed))
        self.navigationItem.leftBarButtonItem = cancelItem
    }
    
    @objc private func cancelButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}
