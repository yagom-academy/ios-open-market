//
//  ProductRegisterView.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/24.
//

import UIKit

class ProductRegisterView: UIView {
    
    weak var delegate: ProductRegisterViewDataSource?
    
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var productImageStackView: UIStackView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!
    @IBOutlet weak var discountedPriceTextField: UITextField!
    @IBOutlet weak var productStockTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var productImageAddButton: UIButton!
    
    let xibName = "ProductRegisterView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadNib()
    }
    
    func reloadData() {
        guard let delegate = delegate else { return }
        productNameTextField.text = delegate.loadName()
        productPriceTextField.text = delegate.loadPrice()
        discountedPriceTextField.text = delegate.loadDiscountedPrice()
        productStockTextField.text = delegate.loadStock()
        descriptionTextView.text = delegate.loadDescription()
        
        (0..<currencySegmentedControl.numberOfSegments).forEach { index in
            if currencySegmentedControl.titleForSegment(at: index) == delegate.loadCurrency() {
                currencySegmentedControl.selectedSegmentIndex = index
                return
            }
        }
        
        productImageStackView.subviews.forEach {
            $0.removed(from: productImageStackView, whenTypeIs: UIImageView.self)
        }
        delegate.loadImage().forEach {
            productImageStackView.insertArrangedSubview(UIImageView(with: $0), at: 0)
        }
    }
    
    private func loadNib() {
        let nib = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        guard let view = nib?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
}

protocol ProductRegisterViewDataSource: AnyObject {
    
    func loadImage() -> [UIImage]
    func loadName() -> String
    func loadPrice() -> String
    func loadCurrency() -> String
    func loadDiscountedPrice() -> String
    func loadStock() -> String
    func loadDescription() -> String
    
}
