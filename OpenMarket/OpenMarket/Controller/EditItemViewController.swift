//
//  EditItemViewController.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/12/07.
//

import UIKit

final class EditItemViewController: UIViewController {
    let editItemView = EditItemView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationBar()
        configureLayout()
    }
    
    private func configureNavigationBar() {
        self.title = "상품수정"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                                style: .plain,
                                                                target: self, action:
                                                                    #selector(tappedCancel(sender:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(tappedDone(sender:)))
    }
    
    @objc private func tappedCancel(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func tappedDone(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditItemViewController {
    func configureLayout() {
        self.view.addSubview(editItemView)
        
        editItemView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            editItemView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            editItemView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            editItemView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            editItemView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
