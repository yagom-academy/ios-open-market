//
//  MainView.swift
//  OpenMarket
//
//  Created by Red, Mino on 2022/05/10.
//

import UIKit

final class MainView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var testLable: UILabel = {
        let label = UILabel()
        label.text = "TEST"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func addSubviews() {
        addSubview(testLable)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            testLable.centerXAnchor.constraint(equalTo: centerXAnchor),
            testLable.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    
}
