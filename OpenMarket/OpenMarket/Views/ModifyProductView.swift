//
//  ModifyProductView.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/12/03.
//

import UIKit

final class ModifyProductView: ProductView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ModifyProductView {
    func bindProductData(product: Product) {
        self.nameTextField.text = product.name
        self.priceTextField.text = String(product.price)
        self.salePriceTextField.text = String(product.bargainPrice)
        self.stockTextField.text = String(product.stock)
        self.descriptionTextView.text = product.description
    }
}
