//
//  EmptyViewController.swift
//  OpenMarket
//
//  Created by 정선아 on 2022/11/27.
//

import UIKit

class EmptyViewController: UIViewController {
    lazy var cancelButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureCancelButton()
        cancelButton.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
    }
    
    @objc private func tapped(sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    private func configureCancelButton() {
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("cancel", for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            cancelButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            cancelButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}
