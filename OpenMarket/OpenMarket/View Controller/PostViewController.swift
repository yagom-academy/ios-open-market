//
//  PostViewController.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/21.
//

import UIKit

class PostViewController: UIViewController {
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var currencySelectButton: UISegmentedControl!
    @IBOutlet weak var bargainPriceTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    let picker = UIImagePickerController()
    var images = [UIImage]()
    var tryAddImageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButtonImage()
        
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "PostCollectionViewCell")
        
        descriptionTextView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        picker.delegate = self
    }
    
    func addButtonImage() {
        guard let image = UIImage(named: "buttonImage") else {
            return
        }
        
        images.append(image)
    }
    
    @objc func pickImage(_ sender: Any) {
        let alert = UIAlertController(title: "사진 불러오기", message: "아무래도 사진앨범이지?", preferredStyle: .actionSheet)
        
        let imageLibrary = UIAlertAction(title: "사진앨범", style: .default) { UIAlertAction in
            self.openImageLibrary()
        }
        
        let camera = UIAlertAction(title: "카메라", style: .default) { UIAlertAction in
            self.openCamera()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(imageLibrary)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func openImageLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        } else {
            let alert = UIAlertController(title: "카메라 접근 실패", message: "해당 기기로는 접근할 수 없습니다", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: Image Scroll View
extension PostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: imageCollectionView.frame.height, height: imageCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: imageCollectionView.frame.height, height: imageCollectionView.frame.height)
    }
}

// MARK: Collection View Data Source, Delegation
extension PostViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath)
        
        guard let typeCastedCell = cell as? PostCollectionViewCell else {
            return cell
        }
        
        cell.layer.borderColor = UIColor.systemGray3.cgColor
        cell.layer.borderWidth = 1.5
        
        typeCastedCell.image.image = images[indexPath.item]
        if tryAddImageCount < 5 {
            let tapToAddImage = UITapGestureRecognizer(target: self, action: #selector(self.pickImage(_:)))
            typeCastedCell.addGestureRecognizer(tapToAddImage)
        }
        
        let layout = imageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = .zero
        layout.scrollDirection = .horizontal
        
        return cell
    }
}

// MARK: Image Picker Controller Delegation
extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // check if it exceed 300KB
            if image.size.width * image.size.height > 75000 {
                let compressedImage = image.compressedImage(targetSize: CGSize(width: 270, height: 270))
                images.insert(compressedImage, at: (images.count - 1))
            } else {
                images.insert(image, at: (images.count - 1))
            }
            
            tryAddImageCount += 1
            
            if images.count > 5 {
                images.removeLast()
            }
            
            self.imageCollectionView.reloadData()
        }
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Bar Button Action(Cancel, Post)
extension PostViewController {
    @IBAction func backToListView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postProduct(_ sender: Any) {
        let checkValidate: Result<ProductParams, ViewControllerError> = checkValidData()
        let urlSessionProvider = URLSessionProvider()
        
        // remove PlusButtonImage
        if tryAddImageCount < 5 {
            images.removeLast()
        }
        
        switch checkValidate {
        case .success(let data):
            urlSessionProvider.postData(requestType: .productRegistration, params: data, images: self.images) { (result: Result<Data, NetworkError>) in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case .failure(let error):
            print(error)
        }
    }
    
    func checkValidData() -> Result<ProductParams, ViewControllerError> {
        guard let name = productNameTextField.text else {
            return .failure(.invalidInput)
        }
        
        guard name.count >= 3 else {
            return .failure(.invalidInput)
        }
        
        guard let priceTextfieldText = priceTextField.text else {
            return .failure(.invalidInput)
        }
        
        guard let price = Double(priceTextfieldText) else {
            return .failure(.invalidInput)
        }
        
        var currency = Currency.KRW
        let currencyIndex = currencySelectButton.selectedSegmentIndex
        switch currencyIndex {
        case 0:
            currency = Currency.KRW
        case 1:
            currency = Currency.USD
        default:
            return .failure(.invalidInput)
        }
        
        guard let discount = Double(bargainPriceTextField.text ?? "0") else {
            return .failure(.invalidInput)
        }
        
        let bargainPrice = price - discount
        
        guard let stock = Int(stockTextField.text ?? "0") else {
            return .failure(.invalidInput)
        }
        
        guard let description = descriptionTextView.text else {
            return .failure(.invalidInput)
        }
        
        return .success(ProductParams(name: name,
                                      descriptions: description,
                                      price: price,
                                      currency: currency,
                                      discountedPrice: bargainPrice,
                                      stock: stock,
                                      secret: "c8%MC*3wjXJ?Wf+g"))
    }
}

// MARK: Text View Delegate
extension PostViewController: UITextViewDelegate {
    @objc
    func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -150
    }
    
    @objc
    func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let textViewPlaceHolder = "등록하실 제품의 상세정보를 입력해주세요"
        
        if self.descriptionTextView.text.isEmpty {
            descriptionTextView.text = textViewPlaceHolder
            descriptionTextView.textColor = .lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let textViewPlaceHolder = "등록하실 제품의 상세정보를 입력해주세요"
        
        if self.descriptionTextView.text == textViewPlaceHolder {
            descriptionTextView.text = nil
            descriptionTextView.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.count <= 1000
    }
}
