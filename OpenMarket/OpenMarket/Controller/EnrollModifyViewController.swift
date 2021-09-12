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
    //    private let photoSelectCell = EnrollModifyPhotoSeclectCell()
    var topItemTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = enrollModifyCollectionViewDataSource
        self.title = "상품" + topItemTitle
        postPatchButton.title = topItemTitle
        collectionView.register(EnrollModifyPhotoSeclectCell.self, forCellWithReuseIdentifier: EnrollModifyPhotoSeclectCell.identifier)
        collectionView.register(EnrollModifyPhotoCell.self, forCellWithReuseIdentifier: EnrollModifyPhotoCell.identifier)
        collectionView.register(EnrollModifyListCell.self, forCellWithReuseIdentifier: EnrollModifyListCell.identifier)
        collectionView.collectionViewLayout = enrollModifyCollectionViewDataSource.createCompositionalLayout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func dd() {
        
    }
}

extension EnrollModifyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("안돼?")
//        let topController = UIApplication.shared.topViewController()
//        guard let VC = topController?.storyboard?.instantiateViewController(identifier: "SecondVC") else { return }
//        present(VC, animated: true, completion: nil)
    }
}
