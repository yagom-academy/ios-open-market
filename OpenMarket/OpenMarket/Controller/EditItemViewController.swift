//
//  EditItemViewController.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/12/07.
//

import UIKit

final class EditItemViewController: ItemViewController {
    let editItemView = ItemView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        super.configureNavigationBar(title: OpenMarketNaviItem.editItemTitle)
    }
    
    override func loadView() {
        self.view = editItemView
    }
    
    func getItemList(id: Int) {
        let url = OpenMarketURL.productComponent(productID: id).url
        
        NetworkManager.publicNetworkManager.getJSONData(url: url, type: Item.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.editItemView.configureItemLabel(data: data)
                case .failure(_):
                    self.showAlertController(title: OpenMarketAlert.networkError, message: OpenMarketAlert.tryAgain)
                }
            }
        }
    }
}
