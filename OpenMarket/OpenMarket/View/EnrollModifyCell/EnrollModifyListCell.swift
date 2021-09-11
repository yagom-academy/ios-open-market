//
//  EnrollModifyListCell.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/10.
//

import UIKit

class EnrollModifyListCell: UICollectionViewCell, UITextFieldDelegate {
    static let identifier = "list"
    private let listTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    override func awakeFromNib() {
        listTextField.delegate = self
        listTextField.autocorrectionType = UITextAutocorrectionType.no
        listTextField.autocapitalizationType = UITextAutocapitalizationType.none
        listTextField.adjustsFontSizeToFitWidth = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    private func setup() {
        contentView.addSubview(listTextField)
        layer.addBorder(edge: .bottom, color: .gray, thickness: 1)
        listTextField.frame = CGRect(x: 0, y: 0,
                                 width: contentView.frame.width,
                                 height: contentView.frame.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(placeholderList: String) {
        listTextField.placeholder = placeholderList
    }
}
