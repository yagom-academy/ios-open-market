//
//  ProductsDetailViewController.swift
//  OpenMarket
//
//  Created by 이은찬 on 2022/07/26.
//

import UIKit

class ProductsDetailViewController: UIViewController {

    let imagePicker = UIImagePickerController()
    let imageChangePicker = UIImagePickerController()
    
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
        
        imageChangePicker.delegate = self
        imageChangePicker.allowsEditing = true
        imageChangePicker.sourceType = .photoLibrary
        
        guard let detailView = view as? ProductDetailView else { return }
        detailView.button.addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)
        
        detailView.itemNameTextField.delegate = self
        detailView.itemPriceTextField.delegate = self
        detailView.itemSaleTextField.delegate = self
        detailView.itemStockTextField.delegate = self
        
        detailView.mainScrollView.keyboardDismissMode = .interactive
        
        detailView.descriptionTextView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        detailView.mainScrollView.addGestureRecognizer(tap)
        
        addNavigationBarButton()
        
        let identifier = "d580792d-0335-11ed-9676-8179e204c0cc"
        let secret = "G3qccGq9uC"
        
        let parameter = Parameters(name: "커피빈", descriptions: "맛있어요", price: 39900, currency: "KRW", secret: secret)
        guard let image = UIImage(named: "coffeebean") else { return }
        
        ProductsDataManager.shared.postData(identifier: identifier, paramter: parameter, image: image) { (data: Page) in
            print(data)
        }
    }

    @objc func endEditing() {
        view.endEditing(true)
    }
    
    @objc func addButtonDidTapped() {
        present(imagePicker, animated: true)
    }
    
    @objc func changeImageButtonTapped() {
        present(imageChangePicker, animated: true)
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
        
        switch picker {
        case imagePicker:
            guard let detailView = view as? ProductDetailView else { return }
            guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
                  let selectedImageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
            let selectedImageKey = selectedImageURL.lastPathComponent
            
            imageCache.setObject(selectedImage, forKey: selectedImageKey as NSString)
            
            detailView.addToScrollView(of: selectedImage, viewController: self)
            
            let imageStackViewCount = detailView.imageStackView.arrangedSubviews.count - 2
            let firstImageView = detailView.imageStackView.arrangedSubviews[imageStackViewCount]
            let tap = UITapGestureRecognizer(target: self, action: #selector(changeImageButtonTapped))
            firstImageView.addGestureRecognizer(tap)
            
            if detailView.imageStackView.arrangedSubviews.count == 6 {
                detailView.button.removeFromSuperview()
            }
        case imageChangePicker:
            guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
            print(selectedImage)
        default:
            break
        }
        
//        print(imageCache.value(forKey: "allObjects") as? NSArray)
        
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

extension ProductsDetailViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let detailView = view as? ProductDetailView else { return }
        guard let textSelectedTextRange = textView.selectedTextRange else { return }
        let caret = textView.caretRect(for: textSelectedTextRange.start)
        let scrollPoint = CGPoint(x: 0, y: caret.origin.y - 50)
        
        if scrollPoint.y != .infinity && scrollPoint.y > 0.0 {
            detailView.mainScrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
}
