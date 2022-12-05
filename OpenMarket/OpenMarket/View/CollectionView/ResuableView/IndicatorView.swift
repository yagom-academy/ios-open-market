//
//  IndicatorView.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/12/05.
//

import UIKit

final class IndicatorView: UICollectionReusableView {
    private var indicatorView: UIView?
    
    func startIndicator() {
        let indicatorView: UIView = UIView(frame: self.bounds)
        indicatorView.backgroundColor = .white
        
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        indicator.center = indicatorView.center
        indicator.startAnimating()
        indicatorView.addSubview(indicator)
        
        addSubview(indicatorView)
        self.indicatorView = indicatorView
    }
    
    override func prepareForReuse() {
        indicatorView?.removeFromSuperview()
        indicatorView = nil
    }
}
