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
    private let delegate = UIApplication.shared.delegate as? AppDelegate
    private var selectIndexPathDictionary: [IndexPath: Bool] = [:]
    private let mainTitle = "상품"
    var topItemTitle: String = ""
    private let photoTotalNumber = 5
    private var photoSelectNumber = 0
    private let cameraImage = UIImage(systemName: "camera")
    private let photoSelectButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoSelectButton.setTitle(
                   "\(photoSelectNumber)/\(photoTotalNumber)", for: .normal)
        photoSelectButton.setImage(cameraImage, for: .normal)
        
        collectionView.dataSource = enrollModifyCollectionViewDataSource
        collectionView.delegate = enrollModifyCollectionViewDelegate
        self.title = mainTitle + topItemTitle
        postPatchButton.title = topItemTitle
        collectionView.register(EnrollModifyPhotoSeclectCell.self, forCellWithReuseIdentifier: EnrollModifyPhotoSeclectCell.identifier)
        collectionView.register(EnrollModifyPhotoCell.self, forCellWithReuseIdentifier: EnrollModifyPhotoCell.identifier)
        collectionView.register(EnrollModifyListCell.self, forCellWithReuseIdentifier: EnrollModifyListCell.identifier)
        collectionView.collectionViewLayout = enrollModifyCollectionViewDataSource.createCompositionalLayout()
        enrollModifyCollectionViewDataSource.butteeen.append(photoSelectButton)
        
        photoSelectButton.addTarget(self, action: #selector(movePhotoAlbum(_:)), for: .touchUpInside)
        configureEnrollModifyDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.changeOrientation = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.changeOrientation = true
    }
    
    func configureEnrollModifyDataSource() {
        enrollModifyCollectionViewDelegate.updateEnrollModifyCollectionViewDataSource(enrollModifyCollectionViewDataSource: enrollModifyCollectionViewDataSource)
    }
    
    @objc func movePhotoAlbum(_ sender: UIButton) {
        guard let convertPhotoAlbumViewController = storyboard?.instantiateViewController(identifier: PhotoAlbumViewController.identifier) as? PhotoAlbumViewController else {
            return
        }
        
        convertPhotoAlbumViewController.selected = { (image: [UIImage]) in
            self.enrollModifyCollectionViewDataSource.photoAlbumImages += image
            self.collectionView.reloadData()
        }
        navigationController?.pushViewController(convertPhotoAlbumViewController, animated: true)
    }
}

