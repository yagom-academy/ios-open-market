//
//  RegisterEditViewController.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/24.
//

import UIKit

class RegisterEditBaseViewController: UIViewController{
    
    private enum Constant {
        static let rightNavigationButtonText = "Done"
        static let leftNavigationButtonText = "Cancel"
    }
    
    enum Mode {
        case add
        case edit
        
        var navigationItemTitle: String {
            switch self{
            case .add:
                return "상품등록"
            case .edit:
                return "상품수정"
            }
        }
    }
    
    var mode: Mode = .add
    
    private lazy var rightNavigationButton = UIBarButtonItem(
        title: Constant.rightNavigationButtonText,
        style: .plain,
        target: self,
        action: #selector(registerEditViewRightBarButtonTapped)
    )
    
    private lazy var leftNavigationButton: UIBarButtonItem = UIBarButtonItem(
        title: Constant.leftNavigationButtonText,
        style: .plain,
        target: self,
        action: #selector(registerEditViewLeftBarButtonTapped)
    )
    
    lazy var addImageScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var addImageHorizontalStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 10
        view.alignment = .leading
        view.distribution = .equalSpacing
        return view
    }()
    
    lazy var baseVerticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            nameTextField,
            priceCurrencyStackView,
            discountPriceTextField,
            stockTextField,
            textView
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    private lazy var priceCurrencyStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [priceTextField, currencySegmentedControl])
        view.axis = .horizontal
        view.spacing = 10
        return view
    }()
    
    private lazy var nameTextField = generateTextField(placeholder: "상품명")
    private lazy var priceTextField = generateTextField(placeholder: "상품가격")
    private lazy var discountPriceTextField = generateTextField(placeholder: "할인가격")
    private lazy var stockTextField = generateTextField(placeholder: "재고수량")
    
    private lazy var currencySegmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["KRW", "USD"])
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.font = .preferredFont(forTextStyle: .body)
        view.text = "제품 상세 설명 textView 입니다."
        //다이나믹타입구현
        return view
    }()
}

// MARK: - Method
extension RegisterEditBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationTitle()
        setConstraint()
    }
    
    private func setNavigationTitle() {
        navigationItem.title = mode.navigationItemTitle
        navigationItem.rightBarButtonItem = rightNavigationButton
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = leftNavigationButton
    }
    
    func setConstraint() {
        view.addSubview(addImageScrollView)
        NSLayoutConstraint.activate([
            addImageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addImageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addImageScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addImageScrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        ])
        
        addImageScrollView.addSubview(addImageHorizontalStackView)
        NSLayoutConstraint.activate([
            addImageHorizontalStackView.leadingAnchor.constraint(equalTo: addImageScrollView.leadingAnchor),
            addImageHorizontalStackView.trailingAnchor.constraint(equalTo: addImageScrollView.trailingAnchor),
            addImageHorizontalStackView.topAnchor.constraint(equalTo: addImageScrollView.topAnchor),
            addImageHorizontalStackView.heightAnchor.constraint(equalTo: addImageScrollView.heightAnchor)
        ])
        
        view.addSubview(baseVerticalStackView)
        NSLayoutConstraint.activate([
            baseVerticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            baseVerticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            baseVerticalStackView.topAnchor.constraint(equalTo: addImageScrollView.bottomAnchor, constant: 15),
            baseVerticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    
    private func generateTextField(placeholder: String) -> UITextField {
        let field = UITextField()
        field.placeholder = "\(placeholder)"
        field.layer.borderColor = UIColor.systemGray4.cgColor
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 5
        NSLayoutConstraint.activate([
            field.heightAnchor.constraint(equalToConstant: 35)
        ])
        return field
    }
}

// MARK: - Action Method
extension RegisterEditBaseViewController {
    
    @objc private func registerEditViewRightBarButtonTapped() {
        
    }
    
    @objc private func registerEditViewLeftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
