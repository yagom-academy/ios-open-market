//
//  LoadingCollectionReusableView.swift
//  OpenMarket
//
//  Created by 이차민 on 2022/01/28.
//

import UIKit

class LoadingCollectionReusableView: UICollectionReusableView {
    let loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.color = .black
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    func configUI() {
        self.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        loadingIndicator.startAnimating()
    }
}
