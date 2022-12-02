//
//  OpenMarket - BaseProductView.swift
//  Created by Zhilly, Dragon. 22/12/02
//  Copyright © yagom. All rights reserved.
//

import UIKit

class BaseProductView: UIView {
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.prepareView()
    }
    
    required init?(coder:NSCoder) {
        super.init(coder:coder)
        prepareView()
    }
    
    func prepareView() {
        
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
