//
//  PhotoAlbumViewController.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/12.
//

import UIKit

class PhotoAlbumViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private let photoAlbumCollecionViewDataSource =
        PhotoAlbumCollecionViewDataSource()
    private let photoAlbumCollectionViewDelegate =
        PhotoAlbumCollectionViewDelegate()
    static let identifier = "PhotoAlbumVC"
    var selected: (([UIImage]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        processCollectionView()
        setUpDataSourceContent()
        decidedCollectionViewLayout()
        registeredIdetifier()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    private func processCollectionView() {
        collectionView.delegate = photoAlbumCollectionViewDelegate
        collectionView.dataSource = photoAlbumCollecionViewDataSource
    }
    
    private func setUpDataSourceContent() {
        photoAlbumCollecionViewDataSource.photoAlbumManager.initializeAllphotos(collectionView: collectionView)
    }
    
   private func decidedCollectionViewLayout() {
        photoAlbumCollecionViewDataSource.decidedListLayout(collectionView)
    }
    
    private func registeredIdetifier() {
        collectionView.register(
            UINib(nibName: PhotoAlbumCell.nibName, bundle: nil),
            forCellWithReuseIdentifier: PhotoAlbumCell.identifier)
    }
    
    @IBAction func resultPhotoButton(_ sender: Any) {
        selected?(photoAlbumCollectionViewDelegate.selectPhotoImage())
        navigationController?.popViewController(animated: true)
    }
}
