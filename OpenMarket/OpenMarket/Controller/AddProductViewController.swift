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
    @IBOutlet weak var addImageButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    var productImages: [NewProductImage] = []
    var isButtonTapped = true
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.navigationController?.navigationBar.topItem?.title = "상품등록"
        setupDescriptionTextView()
    }
    
    @IBAction func tapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func setupDescriptionTextView() {
        setTextViewPlaceHolder()
        setTextViewOutLine()
    }
    
    @IBAction func tapAddImageButton(_ sender: UIButton) {
        isButtonTapped = true
        showSelectImageAlert()
    }
    
    @IBAction func tapProductImage(_ sender: UIButton) {
        isButtonTapped = false
        selectedIndex = sender.tag
        showSelectImageAlert()
    }
    
    func showSelectImageAlert() {
        let alert = createSelectImageAlert()
        present(alert, animated: true, completion: nil)
    }
}

extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func createSelectImageAlert() -> UIAlertController {
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
        if let image = info[.editedImage] as? UIImage {
            editProductImageStackView(with: image)
        } else if let image = info[.originalImage] as? UIImage {
            editProductImageStackView(with: image)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func editProductImageStackView(with image: UIImage) {
        guard isButtonTapped else {
            changeProductImage(with: image)
            return
        }
        addProductImage(with: image)
        if productImageStackView.subviews.count == 6 {
            self.addImageButton.isHidden = true
        }
    }
    
    func changeProductImage(with image: UIImage) {
        guard let selectedImage = productImageStackView.subviews[selectedIndex] as? UIButton else { return }
        selectedImage.setImage(image, for: .normal)
    }
    
    func addProductImage(with image: UIImage) {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tag = productImageStackView.subviews.count
        let lastSubviewIndex = self.productImageStackView.subviews.count - 1
        self.productImageStackView.insertArrangedSubview(button, at: lastSubviewIndex)
        button.addTarget(self, action: #selector(tapProductImage), for: .touchUpInside)
        button.heightAnchor.constraint(equalTo: productImageStackView.heightAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
    }
    
    func addToProductImages(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        let productImage = NewProductImage(image: imageData)
        productImages.append(productImage)
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
