//
//  EmptyViewController.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/27.
//

import UIKit

final class AddItemViewController: UIViewController {
    let addItemView = AddItemView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationBar()
        self.view.addSubview(addItemView)
        configureLayout()
    }
    
    private func configureNavigationBar() {
        self.title = "상품등록"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                                style: .plain,
                                                                target: self, action:
                                                                    #selector(tapped(sender:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(tapped(sender:)))
    }
    
    @objc private func tapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddItemViewController {
    func configureLayout() {
        addItemView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addItemView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            addItemView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            addItemView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            addItemView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
