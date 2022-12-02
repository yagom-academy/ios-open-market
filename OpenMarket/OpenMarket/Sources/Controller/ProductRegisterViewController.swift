//
//  OpenMarket - ProductRegisterViewController.swift
//  Created by Zhilly, Dragon. 22/12/02
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ProductRegisterViewController: UIViewController {
    @IBOutlet weak var mainView: ProductRegisterView!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        registerCellNib()
    }
    
    private func registerCellNib() {
        let collectionViewCellNib = UINib(nibName: ImageCollectionViewCell.stringIdentifier(), bundle: nil)
        
        mainView.collectionView.register(collectionViewCellNib,
                                         forCellWithReuseIdentifier: ImageCollectionViewCell.stringIdentifier())
    }
}

extension ProductRegisterViewController: ProductDelegate {
    func tappedDismissButton() {
        self.dismiss(animated: true)
    }
}

extension ProductRegisterViewController: UICollectionViewDelegate {
}

extension ProductRegisterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ImageCollectionViewCell =
        collectionView.dequeueReusableCell(withReuseIdentifier:
                                            ImageCollectionViewCell.stringIdentifier(),
                                           for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}
