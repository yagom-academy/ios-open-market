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
        self.title = OpenMarketNaviItem.editItemTitle
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: OpenMarketNaviItem.cancel,
                                                                style: .plain,
                                                                target: self, action:
                                                                    #selector(tappedCancel(sender:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: OpenMarketNaviItem.done,
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
    
    func getItemList(id: Int) {
        let url = OpenMarketURL.productComponent(productID: id).url
        
        NetworkManager.publicNetworkManager.getJSONData(url: url, type: Item.self) { itemData in
            DispatchQueue.main.async {
                self.editItemView.configureItemLabel(data: itemData)
            }
        }
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
