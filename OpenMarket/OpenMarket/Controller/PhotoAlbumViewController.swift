//
//  PhotoAlbumViewController.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/12.
//

import UIKit
import Photos.PHAsset

class PhotoAlbumViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private let photoAlbumCollecionViewDataSource = PhotoAlbumCollecionViewDataSource()
    private let photoAlbumCollectionViewDelegate = PhotoAlbumCollectionViewDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(PhotoAlbumCell.nibName)
        
        photoAlbumCollecionViewDataSource.decidedListLayout(collectionView)
        collectionView.delegate = photoAlbumCollectionViewDelegate
        collectionView.dataSource = photoAlbumCollecionViewDataSource
        collectionView.register(UINib(nibName: PhotoAlbumCell.nibName, bundle: nil), forCellWithReuseIdentifier: PhotoAlbumCell.identifier)
    }
}
