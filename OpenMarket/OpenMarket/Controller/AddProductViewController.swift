//
//  addProductViewController.swift
//  OpenMarket
//
//  Created by Seul Mac on 2022/01/19.
//

import UIKit

class AddProductViewController: UIViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var productImageStackView: UIStackView!
    
    let imagePicker = UIImagePickerController()
    var productImages: [NewProductImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.navigationController?.navigationBar.topItem?.title = "상품등록"
        setupDescriptionTextView()
    }
    
    @IBAction func tapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func setupDescriptionTextView() {
        setTextViewPlaceHolder()
        setTextViewPlaceHolder()
    }
    
    @IBAction func tapAddImageButton(_ sender: UIButton) {
        let alert = createAddImageAlert()
        present(alert, animated: true, completion: nil)
    }
}

extension AddProductViewController: UITextViewDelegate {
    
    func setTextViewOutLine() {
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.systemGray4.cgColor
        descriptionTextView.layer.cornerRadius = 5
    }
    
    func setTextViewPlaceHolder() {
        descriptionTextView.delegate = self
        descriptionTextView.text = "상품 설명(1,000자 이내)"
        descriptionTextView.textColor = .lightGray
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let cunrrentText = descriptionTextView.text else { return true }
        let newLength = cunrrentText.count + text.count - range.length
        return newLength <= 1000
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = "상품 설명(1,000자 이내)"
                textView.textColor = UIColor.lightGray
            }
        }
}

extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func createAddImageAlert() -> UIAlertController {
        let alert = UIAlertController(title: "상품사진 선택", message: nil, preferredStyle: .actionSheet)
        let photoLibrary = UIAlertAction(title: "사진앨범", style: .default) { action in
            self.openPhotoLibrary()
        }
        let camera = UIAlertAction(title: "카메라", style: .default) { action in
            self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(photoLibrary)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        return alert
    }
    
    func openPhotoLibrary() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: false, completion: nil)
    }
    
    func openCamera() {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            addToStackView(image: image)
            addToProductImages(image: image)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func addToStackView(image: UIImage) {
        let imageView = UIImageView()
        imageView.image = image
        let lastSubviewIndex = self.productImageStackView.subviews.count - 1
        self.productImageStackView.insertArrangedSubview(imageView, at: lastSubviewIndex)
    }
    
    func addToProductImages(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        let productImage = NewProductImage(image: imageData)
        productImages.append(productImage)
    }
}
