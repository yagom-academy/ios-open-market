//
//  OpenMarket - ProductRegisterViewController.swift
//  Created by Zhilly, Dragon. 22/12/02
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ProductRegisterViewController: UIViewController {
    var productView: ProductRegisterView = ProductRegisterView()
    
    @IBOutlet weak var mainView: ProductRegisterView!
    
    override func loadView() {
        super.loadView()
        mainView = productView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productView.delegate = self
        productView.collectionView.delegate = self
    }
}

extension ProductRegisterViewController: ProductDelegate {
    func tappedDismissButton() {
        self.dismiss(animated: true)
    }
}

extension ProductRegisterViewController: UICollectionViewDelegate {
}

//extension ProductRegisterViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    }
//}
