//
//  EnrollModifyViewController.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/10.
//

import UIKit

class EnrollModifyViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var postPatchButton: UIBarButtonItem!
    
    private let enrollModifyCollectionViewDataSource = EnrollModifyCollectionViewDataSource()
    private let compositionalLayout = CompositionalLayout()
    var topItemTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = enrollModifyCollectionViewDataSource
        self.title = "상품" + topItemTitle
        postPatchButton.title = topItemTitle
        collectionView.register(EnrollModifyPhotoCell.self, forCellWithReuseIdentifier: EnrollModifyPhotoCell.Identifier)
        decidedPhotoCellLayout()
    }
    
    private func decidedPhotoCellLayout() {
        let cellMargin =
            compositionalLayout.margin(top: 5, leading: 0, bottom: 5, trailing: 5)
        let viewMargin =
            compositionalLayout.margin(top: 0, leading: 5, bottom: 0, trailing: 0)
        collectionView.collectionViewLayout =
            compositionalLayout.create(portraitHorizontalNumber: 3,
                                       landscapeHorizontalNumber: 5,
                                       cellVerticalSize: .fractionalHeight(1/5),
                                       scrollDirection: .horizontal,
                                       cellMargin: cellMargin, viewMargin: viewMargin)
    }
    
}
