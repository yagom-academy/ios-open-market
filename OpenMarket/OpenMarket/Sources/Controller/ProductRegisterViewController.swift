//
//  OpenMarket - ProductRegisterViewController.swift
//  Created by Zhilly, Dragon. 22/12/02
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ProductRegisterViewController: UIViewController {
    var imageArray: [UIImage] = []
    let imagePicker: UIImagePickerController = .init()
    var imageIndex: Int = 0
    @IBOutlet weak var mainView: ProductRegisterView!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        
        configureCollectionView()
        configureImagePicker()
    }
    
    private func configureCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        registerCellNib()
    }
    
    private func registerCellNib() {
        let collectionViewCellNib = UINib(nibName: ImageCollectionViewCell.stringIdentifier(), bundle: nil)
        
        mainView.collectionView.register(collectionViewCellNib,
                                         forCellWithReuseIdentifier: ImageCollectionViewCell.stringIdentifier())
    }
    
    private func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        imageArray.append(UIImage(named: "PlusImage") ?? UIImage())
    }
}

extension ProductRegisterViewController: ProductDelegate {
    func tappedDismissButton() {
        self.dismiss(animated: true)
    }
}

extension ProductRegisterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if imageArray.count - 1 != indexPath.item && imageArray.count < 7 {
            let alert = UIAlertController(title: "이미지 편집", message: nil, preferredStyle: .actionSheet)
            let edit = UIAlertAction(title: "수정", style: .default) { _ in
                self.imageIndex = indexPath.item
                self.imageArray.remove(at: indexPath.item)
                self.present(self.imagePicker, animated: true)
            }
            let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
                self.imageArray.remove(at: indexPath.item)
                self.mainView.collectionView.reloadData()
            }
            
            alert.addAction(edit)
            alert.addAction(delete)
            present(alert, animated: true)
        } else {
            if imageArray.count < 6 {
                present(imagePicker, animated: true)
            } else {
                let alert = UIAlertController(title: "안내", message: "사진 추가는 최대 5장입니다.", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default)
                
                alert.addAction(action)
                present(alert, animated: true)
            }
        }
    }
}

extension ProductRegisterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ImageCollectionViewCell =
        collectionView.dequeueReusableCell(withReuseIdentifier:
                                            ImageCollectionViewCell.stringIdentifier(),
                                           for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.image.image = imageArray[indexPath.item]
        
        return cell
    }
}

extension ProductRegisterViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        imageArray.insert(image, at: 0)
        mainView.collectionView.reloadData()
        
        dismiss(animated: true)
    }
}

extension ProductRegisterViewController: UINavigationControllerDelegate {
    
}
