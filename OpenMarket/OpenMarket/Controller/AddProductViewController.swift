//
//  addProductViewController.swift
//  OpenMarket
//
//  Created by Seul Mac on 2022/01/19.
//

import UIKit

class AddProductViewController: UIViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    let imagePicker = UIImagePickerController()
    
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

extension AddProductViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func openPhotoLibrary() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: false, completion: nil)
    }
    
    func openCamera() {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: false, completion: nil)
    }
}
