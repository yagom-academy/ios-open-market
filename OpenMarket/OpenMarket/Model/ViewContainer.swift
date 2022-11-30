//
//  ViewContainer.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/30.
//

import UIKit.UIView

struct ViewContainer: Hashable {
    let identifier: UUID
    let view: UIView
    
    init(identifier: UUID = UUID(), view: UIView) {
        self.identifier = identifier
        self.view = view
    }
}
