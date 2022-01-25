//
//  PostProductViewController.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/21.
//

import UIKit

class EditProductViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var postImageListCollectionView: UICollectionView!
    @IBOutlet weak var postImageButton: UIButton!
    @IBOutlet weak var postImageListStackView: UIStackView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var currencySwitchController: UISegmentedControl!
    @IBOutlet weak var discountedPriceTextField: UITextField!
    @IBOutlet weak var productStockTextField: UITextField!
    @IBOutlet weak var productNavigationBar: UINavigationItem!
    let imagePickerController = UIImagePickerController()
    let alertController = UIAlertController(title: "사진 추가", message: nil, preferredStyle: .actionSheet)
//    var postData: ProductParam
    var tempPostImage: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePickerController.delegate = self
        placeholderSetting()
        addImageAlert()
        
        postImageListCollectionView.delegate = self
        postImageListCollectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        postImageListCollectionView.collectionViewLayout = flowLayout
        postImageListCollectionView.isPagingEnabled = true
    }
    
    @IBAction func hitCancelButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hitDoneButton(_ sender: Any) {
//        postData.name = productNameTextField.text
//        postData.price = productPriceTextField.text
//        postData.discountedPrice = discountedPriceTextField.text
//        postData.stock = productStockTextField.text
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hitPostImageButton(_ sender: Any) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    func placeholderSetting() {
        productNameTextField.delegate = self
        productPriceTextField.delegate = self
        discountedPriceTextField.delegate = self
        productStockTextField.delegate = self
        productNameTextField.placeholder = "상품명"
        productPriceTextField.placeholder = "상품가격"
        discountedPriceTextField.placeholder = "할인금액"
        productStockTextField.placeholder = "재고수량"
    }
    
    func addImageAlert() {
        let photoLibraryAlert = UIAlertAction(title: "사진앨범", style: .default) { _ in
            self.openAlbum()
        }
        let cancelAlert = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        self.alertController.addAction(photoLibraryAlert)
        self.alertController.addAction(cancelAlert)
    }
    
    func openAlbum() {
        self.imagePickerController.sourceType = .photoLibrary
        self.imagePickerController.allowsEditing = true
        present(self.imagePickerController, animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editProductView = segue.destination as? EditProductViewController {
            editProductView.productNavigationBar.title = "상품수정"
        }
    }
}


extension EditProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = image
        }
        tempPostImage.append(newImage ?? UIImage())
        postImageListCollectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempPostImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as? ProductImageCell else {
            return ProductImageCell()
        }
        
        cell.previewImageView.image = tempPostImage[indexPath.item]
        
            return cell
    }
}

extension EditProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 125)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
        
    }
}
