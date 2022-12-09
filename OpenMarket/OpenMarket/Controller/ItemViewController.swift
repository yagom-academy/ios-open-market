//
//  ItemViewController.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/12/09.
//

import UIKit

class ItemViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureNavigationBar(title: String) {
        self.title = title
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: OpenMarketNaviItem.cancel,
                                                                style: .plain,
                                                                target: self, action:
                                                                    #selector(tappedCancel(sender:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: OpenMarketNaviItem.done,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(tappedDone(sender:)))
    }
    
    @objc func tappedCancel(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tappedDone(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
