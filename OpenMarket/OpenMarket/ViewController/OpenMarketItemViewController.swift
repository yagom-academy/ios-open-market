//
//  OpenMarketItemViewController.swift
//  OpenMarket
//
//  Created by James on 2021/06/14.
//

import UIKit

class OpenMarketItemViewController: UIViewController {
    
    // MARK: - Properties
    
    private let currencyList = ["KRW", "USD", "BTC", "JPY", "EUR", "GBP", "CNY"]
    private let imagePicker = UIImagePickerController()
    var itemThumbnails: [UIImage] = []
    
    // MARK: - Views
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명:"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        return textField
    }()
    
    private lazy var currencyTextField: UITextField = {
        let textField = UITextField()
        textField.inputView = currencyPickerView
        textField.inputAccessoryView = pickerViewToolbar
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "가격:"
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var discountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "(optional) 할인 가격:"
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var stockTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "수량:"
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var detailedInformationTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .darkGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        return textView
    }()
    
    private lazy var currencyPickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 300))
        pickerView.backgroundColor = UIColor.white
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private lazy var pickerViewToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.donePicker))
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.donePicker))
        
        toolbar.setItems([doneButton, cancelButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        return toolbar
    }()
    
    private lazy var uploadImageButton: UIButton = {
        let button = UIButton()
        let uploadImage = UIImage(systemName: "camera")
        button.setImage(uploadImage, for: .normal)
        button.addTarget(self, action: #selector(didTapUploadPhoto(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var thumbnailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImagePickerCollectionViewCell.self, forCellWithReuseIdentifier: OpenMarketGridCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private lazy var thumbnailView: UIView = {
        let view = UIView()
        for index in 0..<itemThumbnails.count {
            let imageView = UIImageView()
            imageView.image = itemThumbnails[index]
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
                imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            ])
            
            let button = UIButton()
            button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
            button.imageView?.tintColor = .gray
            button.backgroundColor = .clear
            button.layer.cornerRadius = 10
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: view.topAnchor, constant: 7),
                button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -7),
            ])
            
            button.addTarget(self, action: #selector(clickToRemoveThumbnail), for: .touchDown)
            
            view.addSubview(imageView)
            view.addSubview(button)
        }
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        currencyPickerView.dataSource = self
        currencyPickerView.delegate = self
        detailedInformationTextView.delegate = self
    }
}
extension OpenMarketItemViewController {
    
    // MARK: - setUp UI Constraints
    
    private func addSubviews() {
        
    }
    
    private func setUpUIConstraints() {
        
    }
    
    
    @objc private func clickToRemoveThumbnail() {
        
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension OpenMarketItemViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyTextField.text = currencyList[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currencyList.count
    }
    
    @objc private func donePicker() {
        currencyTextField.resignFirstResponder()
    }
}

// MARK: - UITextViewDelegate

extension OpenMarketItemViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "상품 정보를 입력 해 주세요."
            textView.textColor = .lightGray
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension OpenMarketItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage: UIImage = info[.originalImage] as? UIImage else { return }
        
        selectedImage.jpegData(compressionQuality: 0.75)
        itemThumbnails.append(selectedImage)
        thumbnailCollectionView.reloadData()
    }
    
    @objc func didTapUploadPhoto(_ sender: UIButton) {
        let alertController = UIAlertController(title: "상품등록", message: nil, preferredStyle: .actionSheet)
        let photoLibrary = UIAlertAction(title: "사진 앨범", style: .default) { action in
            self.openLibrary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(photoLibrary)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func openLibrary() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension OpenMarketItemViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemThumbnails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickerCollectionViewCell.identifier, for: indexPath) as? ImagePickerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.indexPath = indexPath
        cell.configureThumbnail(itemThumbnails)
        cell.imagePickerDelegate = cell
        cell.removeCellDelegate = self
        return cell
    }
}
extension OpenMarketItemViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - Cell Size
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width / 5
        let cellHeight = collectionView.frame.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - RemoveDelegate

extension OpenMarketItemViewController: RemoveDelegate {
    func removeCell(_ indexPath : IndexPath) {
            self.thumbnailCollectionView.performBatchUpdates {
                self.thumbnailCollectionView.deleteItems(at: [indexPath])
                self.itemThumbnails.remove(at: indexPath.row)
            } completion: { (_) in
                self.thumbnailCollectionView.reloadData()
            }
    }
}
