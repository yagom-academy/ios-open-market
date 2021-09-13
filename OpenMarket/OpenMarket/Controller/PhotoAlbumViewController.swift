//
//  PhotoAlbumViewController.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/12.
//

import UIKit

class PhotoAlbumViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private let photoAlbumCollecionViewDataSource = PhotoAlbumCollecionViewDataSource()
    private let photoAlbumCollectionViewDelegate = PhotoAlbumCollectionViewDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoAlbumCollecionViewDataSource.decidedListLayout(collectionView)
        photoAlbumCollecionViewDataSource.requestImage(collectionView: collectionView)
        collectionView.delegate = photoAlbumCollectionViewDelegate
        collectionView.dataSource = photoAlbumCollecionViewDataSource
        collectionView.register(UINib(nibName: PhotoAlbumCell.nibName, bundle: nil), forCellWithReuseIdentifier: PhotoAlbumCell.identifier)
        
    }
    
    @IBAction func resultPhotoButton(_ sender: Any) {
        let send = photoAlbumCollectionViewDelegate.selectPhotoIndext()
//        delegate?.sendData(data: send)
        navigationController?.popViewController(animated: true)
    }
}
