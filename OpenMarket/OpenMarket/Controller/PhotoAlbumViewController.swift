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
    static let identifier = "photoAlbumVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoAlbumCollecionViewDataSource
        collectionView.register(PhotoAlbumCell.self, forCellWithReuseIdentifier: PhotoAlbumCell.identifier)
    }
}
