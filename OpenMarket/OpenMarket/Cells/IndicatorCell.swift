//
//  IndicateCell.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/04.
//

import UIKit

class IndicatorCell: UICollectionViewCell {
    var indicator : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){
        contentView.addSubview(indicator)
        indicator.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        indicator.startAnimating()
    }
    
}
