//
//  AddProductViewController.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/29.
//

import UIKit

class AddProductViewController: UIViewController {
    
    @IBOutlet weak var addImageCollectionView: UICollectionView!

    let imagePicker = UIImagePickerController()
    var numberOfCell = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.imagePicker.sourceType = .photoLibrary
//        self.imagePicker.allowsEditing = true
//        self.imagePicker.delegate = self
        self.addImageCollectionView.delegate = self
        self.addImageCollectionView.dataSource = self
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func pickImage() {
        self.present(self.imagePicker, animated: true)
    }
}

extension AddProductViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return numberOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddProductCollectionViewCell.reuseIdentifier, for: indexPath) as! AddProductCollectionViewCell
        cell.backgroundColor = .black
        //cell.profileImageView.image = .add
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        numberOfCell += 1
        collectionView.reloadData()
    }
}

extension AddProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        flowayout?.scrollDirection = .horizontal
        flowayout?.minimumLineSpacing = 20
        flowayout?.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return CGSize(width: view.frame.width - 100, height: view.frame.height - 150)
    }
}

//extension AddProductViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        var newImage: UIImage? = nil
//
//        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            newImage = possibleImage
//        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            newImage = possibleImage
//        }
//
//        //profileImageView.image = newImage
//    }
//}
