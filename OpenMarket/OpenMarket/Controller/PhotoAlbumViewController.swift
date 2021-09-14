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
    static let identifier = "PhotoAlbumVC"
    var selected: (([UIImage]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoAlbumCollecionViewDataSource.decidedListLayout(collectionView)
        photoAlbumCollecionViewDataSource.requestImage(collectionView: collectionView)
        collectionView.delegate = photoAlbumCollectionViewDelegate
        collectionView.dataSource = photoAlbumCollecionViewDataSource
        collectionView.register(UINib(nibName: PhotoAlbumCell.nibName, bundle: nil), forCellWithReuseIdentifier: PhotoAlbumCell.identifier)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    func selectPhotoAlbumImage() -> [UIImage] {
        let indexes = photoAlbumCollectionViewDelegate.selectPhotoIndex()
        let photoAlbumImages = photoAlbumCollecionViewDataSource.photoAlbumImages
        let selectPhotos = indexes.map { photoAlbumImages[$0]}
        return selectPhotos
        
    }
    
    @IBAction func resultPhotoButton(_ sender: Any) {
        selected?(selectPhotoAlbumImage())
        navigationController?.popViewController(animated: true)
    }
}
