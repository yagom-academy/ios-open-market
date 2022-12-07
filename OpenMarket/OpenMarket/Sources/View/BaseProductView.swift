//
//  OpenMarket - BaseProductView.swift
//  Created by Zhilly, Dragon. 22/12/02
//  Copyright © yagom. All rights reserved.
//

import UIKit

protocol ProductDelegate {
    func tappedDismissButton()
    func tappedDoneButton()
}

class BaseProductView: UIView {
    var delegate: ProductDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productBargainTextField: UITextField!
    @IBOutlet weak var productStockTextField: UITextField!
    @IBOutlet weak var productsContentTextView: UITextView!
    @IBOutlet weak var currencySelector: UISegmentedControl!
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        prepareView()
        loadXib()
    }
    
    required init?(coder:NSCoder) {
        super.init(coder:coder)
        prepareView()
        loadXib()
    }
    
    func prepareView() {}
    
    private func loadXib() {
        let identifier = "BaseProductView"
        let nibs = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)
        guard let view = nibs?.first as? UIView else { return }
        
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        delegate?.tappedDismissButton()
    }
    
    @IBAction func tapDoneButton(_ sender: UIButton) {
        delegate?.tappedDoneButton()
    }
}

// 등록하는 뷰
class ProductRegisterView: BaseProductView {
    override func prepareView() {
        
    }
}

// 수정하는 뷰
class ProductChangeView: BaseProductView {
    override func prepareView() {
        
    }
}
