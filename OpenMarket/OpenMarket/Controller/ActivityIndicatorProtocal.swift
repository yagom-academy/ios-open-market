//
//  activityIndicatorProtocol.swift
//  OpenMarket
//
//  Created by 우롱차 on 2022/06/09.
//

import UIKit

protocol ActivityIndicatorProtocol: UIViewController {
    var activityIndicator: UIActivityIndicatorView { get }
    
    func configureIndicator()
}

extension ActivityIndicatorProtocol {
    func configureIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}
