//
//  RegisterProductViewController.swift
//  OpenMarket
//
//  Created by baem, minii on 2022/12/02.
//

import UIKit

class RegisterProductViewController: UIViewController {
    
    let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "상품명"
        
        return textField
    }()
    
    let productPriceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "상품가격"
        
        return textField
    }()
    
    let discountPriceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "할인금액"
        
        return textField
    }()
    
    let stockTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "재고수량"
        
        return textField
    }()
    
    let currencySegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: Currency.allCases.map(\.rawValue))
        
        return segment
    }()
    
    let descriptionTextView: UITextView = {
        let textview = UITextView()
        textview.text = "국회는 국민의 보통·평등·직접·비밀선거에 의하여 선출된 국회의원으로 구성한다. 법률이 헌법에 위반되는 여부가 재판의 전제가 된 경우에는 법원은 헌법재판소에 제청하여 그 심판에 의하여 재판한다.\n\n법률은 특별한 규정이 없는 한 공포한 날로부터 20일을 경과함으로써 효력을 발생한다. 대통령은 헌법과 법률이 정하는 바에 의하여 국군을 통수한다. 헌법재판소 재판관은 정당에 가입하거나 정치에 관여할 수 없다."
        textview.font = .preferredFont(forTextStyle: .title3)
        
        return textview
    }()
    
    lazy var segmentStackview: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .fill
        stackview.addArrangedSubview(productPriceTextField)
        stackview.addArrangedSubview(currencySegment)
        stackview.spacing = 8
        currencySegment.widthAnchor.constraint(equalTo: productPriceTextField.widthAnchor, multiplier: 0.30).isActive = true
        
        return stackview
    }()
    
    lazy var totalStackview: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .equalSpacing
        stackview.spacing = 8
        [
            productNameTextField,
            segmentStackview,
            discountPriceTextField,
            stockTextField
        ].forEach {
            stackview.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        return stackview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didtappedDoneButton)
        )
        navigationController?.title = "상품등록"
        
        view.addSubview(totalStackview)
        view.addSubview(descriptionTextView)
        totalStackview.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            totalStackview.topAnchor.constraint(equalTo: safeArea.topAnchor),
            totalStackview.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            totalStackview.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            descriptionTextView.topAnchor.constraint(equalTo: totalStackview.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            descriptionTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    @objc func didtappedDoneButton() {
        
    }
}
