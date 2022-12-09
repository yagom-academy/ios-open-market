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
        
        NetworkManager.publicNetworkManager.getJSONData(url: url, type: Item.self) { itemData in
            DispatchQueue.main.async {
                self.editItemView.configureItemLabel(data: itemData)
            }
        }
    }
}
