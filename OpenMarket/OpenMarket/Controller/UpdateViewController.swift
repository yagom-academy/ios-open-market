//
//  UpdateViewController.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/29.
//

import UIKit

final class UpdateViewController: UIViewController {
    private let productInformationView: ProductInformationView = ProductInformationView()
    private let imagePickerButton: UIButton = {
        let button: UIButton = UIButton()
        
        button.setTitle("+", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray4
        
        return button
    }()
    private var viewContainers: [ViewContainer] = [] {
        didSet {
            applyViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = productInformationView

        productInformationView.textFieldDelegate = self
        productInformationView.descriptionTextViewDelegate = self
        applyViews()
    }
    
    private func applyViews() {
        var snapshot: NSDiffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, ViewContainer>()
        var temporaryViewContainers = viewContainers
        if temporaryViewContainers.count < 5 {
            temporaryViewContainers.append(ViewContainer(view: imagePickerButton))
        }
        snapshot.appendSections([.main])
        snapshot.appendItems(temporaryViewContainers)
        productInformationView.applySnapshot(snapshot)
    }
}

extension UpdateViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let _: NumberTextField = textField as? NumberTextField,
           string.isNumber() == false {
            return false
        } else if let nameTextField: NameTextField = textField as? NameTextField,
                  let text: String = nameTextField.text {
            let lengthOfTextToAdd: Int = string.count - range.length
            let addedTextLength: Int = text.count + lengthOfTextToAdd
            
            return nameTextField.isLessThanOrEqualMaximumLength(addedTextLength)
        }
        return true
    }
}

extension UpdateViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let descriptionTextView: DescriptionTextView = textView as? DescriptionTextView {
            let lengthOfTextToAdd: Int = text.count - range.length
            let addedTextLength: Int = textView.text.count + lengthOfTextToAdd
            
            return descriptionTextView.isLessThanOrEqualMaximumLength(addedTextLength)
        }

        return true
    }
}
