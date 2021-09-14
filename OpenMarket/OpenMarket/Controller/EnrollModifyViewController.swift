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
    private let delegate = UIApplication.shared.delegate as? AppDelegate
    var topItemTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = enrollModifyCollectionViewDataSource
        collectionView.delegate = self
        self.title = "상품" + topItemTitle
        postPatchButton.title = topItemTitle
        collectionView.register(EnrollModifyPhotoSeclectCell.self, forCellWithReuseIdentifier: EnrollModifyPhotoSeclectCell.identifier)
        collectionView.register(EnrollModifyPhotoCell.self, forCellWithReuseIdentifier: EnrollModifyPhotoCell.identifier)
        collectionView.register(EnrollModifyListCell.self, forCellWithReuseIdentifier: EnrollModifyListCell.identifier)
        collectionView.collectionViewLayout = enrollModifyCollectionViewDataSource.createCompositionalLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.changeOrientation = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.changeOrientation = true
    }
}

extension EnrollModifyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == .zero && indexPath.section == .zero {
            guard let convertPhotoAlbumViewController = storyboard?.instantiateViewController(identifier: PhotoAlbumViewController.identifier) as? PhotoAlbumViewController else {
                return
            }
            convertPhotoAlbumViewController.selected = { (image: [UIImage]) in
                self.enrollModifyCollectionViewDataSource.photoAlbumImages += image
                collectionView.reloadData()
            }
            navigationController?.pushViewController(convertPhotoAlbumViewController, animated: true)
        }
    }
}
