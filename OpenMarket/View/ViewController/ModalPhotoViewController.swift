//
//  ModalPhotoViewController.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/28.
//

import UIKit

class ModalPhotoViewController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView!
    static var selectedImageCount = 0
    var imageCollectionView: UICollectionView?
        
    @IBAction private func completeChoosingImage(_ sender: Any) {
        self.imageCollectionView?.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func cancelChoosingImage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let PhotoCollectionViewCellNib = UINib(nibName: PhotoCollectionViewCell.identifier, bundle: nil)
        self.collectionView.register(PhotoCollectionViewCellNib, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }
    
}

extension ModalPhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Cache.shared.imageFiles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else  {
            return UICollectionViewCell()
        }
        cell.itemImage.image = UIImage(named:Cache.shared.imageFiles[indexPath.item])
        cell.imageFileName = Cache.shared.imageFiles[indexPath.item]
        return cell
    }
    
}

extension ModalPhotoViewController: UICollectionViewDelegate {
    
}

extension ModalPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width/3.5, height: collectionView.frame.width/3.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}

extension UIViewController {

    func dismissKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
}
