//
//  failImageView.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/16.
//

import UIKit

class FailView: UIView {
    let failImageView: UIImageView = {
        let loadingImageView = UIImageView()
        loadingImageView.image = UIImage(named: "fail")
        loadingImageView.contentMode = .scaleAspectFit
        
        return loadingImageView
    }()
    
    let failLabel: UILabel = {
        let failLabel = UILabel()
        failLabel.text = "내 인생에 실패란 없다 - 코다"
        failLabel.font.withSize(20)
        
        return failLabel
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 30
        
        return stackView
    }()
    
    func configure(viewController: UIViewController) {
        viewController.view.addSubview(stackView)
        stackView.addArrangedSubview(failImageView)
        stackView.addArrangedSubview(failLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: viewController.view.widthAnchor, multiplier: 0.7),
            stackView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
        ])
    }
}
