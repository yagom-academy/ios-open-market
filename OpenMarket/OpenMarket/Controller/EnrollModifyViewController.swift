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
    private let enrollModifyCollectionViewDelegate = EnrollModifyCollectionViewDelegate()
    private let compositionalLayout = CompositionalLayout()
    var topItemTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = enrollModifyCollectionViewDataSource
        self.title = "상품" + topItemTitle
        postPatchButton.title = topItemTitle
        collectionView.register(EnrollModifyPhotoCell.self, forCellWithReuseIdentifier: EnrollModifyPhotoCell.identifier)
        collectionView.register(EnrollModifyListCell.self, forCellWithReuseIdentifier: EnrollModifyListCell.identifier)
        collectionView.collectionViewLayout = enrollModifyCollectionViewDataSource.createCompositionalLayout()
    }
}
