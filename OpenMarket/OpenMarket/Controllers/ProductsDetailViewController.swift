//
//  ProductsDetailViewController.swift
//  OpenMarket
//
//  Created by 이은찬 on 2022/07/26.
//

import UIKit

class ProductsDetailViewController: UIViewController {

    let imagePicker = UIImagePickerController()
    
    let imageCache = NSCache<NSString, UIImage>()
    
    override func loadView() {
        view = ProductDetailView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "상품등록"
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        guard let detailView = view as? ProductDetailView else { return }
        detailView.button.addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)
        
        detailView.itemNameTextField.delegate = self
        detailView.itemPriceTextField.delegate = self
        detailView.itemSaleTextField.delegate = self
        detailView.itemStockTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        detailView.mainScrollView.addGestureRecognizer(tap)
        
        addNavigationBarButton()
        
    }

    @objc func endEditing() {
        view.endEditing(true)
    }
    
    @objc func addButtonDidTapped() {
        present(imagePicker, animated: true)
    }
    
    func addNavigationBarButton() {
        navigationController?.navigationBar.topItem?.title = "Cancel"
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
    }
}

extension ProductsDetailViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let detailView = view as? ProductDetailView else { return }
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
              let selectedImageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
        let selectedImageKey = selectedImageURL.lastPathComponent
        
        imageCache.setObject(selectedImage, forKey: selectedImageKey as NSString)
        
        detailView.addToScrollView(of: selectedImage, viewController: self)
        detailView.imageStackView.arrangedSubviews.last
        
        if detailView.imageStackView.arrangedSubviews.count == 6 {
            detailView.button.removeFromSuperview()
        }
        
        
        
        print(imageCache.value(forKey: "allObjects") as? NSArray)
        
        
        dismiss(animated: true)
    }
}

extension ProductsDetailViewController: UITextFieldDelegate {
    private func textFieldshouldBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
