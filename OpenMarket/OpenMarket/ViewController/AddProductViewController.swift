//
//  AddProductViewController.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/29.
//

import UIKit

class AddProductViewController: UIViewController {
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var pickerImageStackView: UIStackView!
    @IBOutlet weak var pikerImageView: UIView!
    
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImagePicker()
    }
    
    @IBAction private func back(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction private func addImageClick(_ sender: Any) {
        pickImage()
    }
    
    @objc private func pickImage() {
        self.present(self.imagePicker, animated: true)
    }
    
    private func fetchImagePicker() {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
    }
    
    private func fetchPickerImageView(image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: pikerImageView.frame.width),
            imageView.heightAnchor.constraint(equalToConstant: pikerImageView.frame.height)
        ])
        
        return imageView
    }
}

extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        else { return }
        
        let imageView = fetchPickerImageView(image: editedImage)
        pickerImageStackView.insertArrangedSubview(imageView, at: .zero)
        dismiss(animated: true, completion: nil)
    }
}
