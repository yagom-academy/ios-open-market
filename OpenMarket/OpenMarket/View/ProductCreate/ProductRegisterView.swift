//
//  ProductRegisterView.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/24.
//

import UIKit

class ProductRegisterView: UIView {
    
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
    
    private func loadNib() {
        let nib = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        guard let view = nib?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
}
