//
//  LoadingImageView.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/16.
//

import UIKit

class LoadingImageView: UIView {
    let loadingImageView: UIImageView = {
        let loadingImageView = UIImageView()
        loadingImageView.image = UIImage(named: "yagom")
        
        return loadingImageView
    }()
    
    func configure(viewController: UIViewController) {
        viewController.view.addSubview(loadingImageView)
        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingImageView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            loadingImageView.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
        ])
    }
}
