//
//  OpenMarket - ProductRegisterViewController.swift
//  Created by Zhilly, Dragon. 22/12/02
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ProductRegisterViewController: UIViewController {
    var imageArray: [UIImage] = []
    let imagePicker: UIImagePickerController = .init()
    var imageIndex: Int = 0
    var keyHeight: CGFloat = 0
    @IBOutlet weak var mainView: ProductRegisterView!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        
        configureCollectionView()
        configureImagePicker()
        checkKeyboard()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
    }
    
    private func checkKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        registerCellNib()
    }
    
    private func registerCellNib() {
        let collectionViewCellNib = UINib(nibName: ImageCollectionViewCell.stringIdentifier(), bundle: nil)
        
        mainView.collectionView.register(collectionViewCellNib,
                                         forCellWithReuseIdentifier: ImageCollectionViewCell.stringIdentifier())
    }
    
    private func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        imageArray.append(UIImage(named: "PlusImage") ?? UIImage())
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        guard let senderUserInfo = sender.userInfo else { return }
        let userInfo:NSDictionary = senderUserInfo as NSDictionary
        if let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            var keyboardHeight = keyboardRectangle.height
            
            if keyHeight == 0 {
                keyHeight = keyboardHeight
                view.frame.size.height -= keyboardHeight
            } else if keyHeight > keyboardHeight {
                keyboardHeight = keyboardHeight - keyHeight
                keyHeight = keyHeight + keyboardHeight
                view.frame.size.height -= keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        view.frame.size.height += keyHeight
        keyHeight = 0
    }
}

extension ProductRegisterViewController: ProductDelegate {
    func tappedDismissButton() {
        self.dismiss(animated: true)
    }
}

extension ProductRegisterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

extension ProductRegisterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if imageArray.count - 1 != indexPath.item && imageArray.count < 7 {
            let alert = UIAlertController(title: "이미지 편집", message: nil, preferredStyle: .actionSheet)
            let edit = UIAlertAction(title: "수정", style: .default) { _ in
                self.imageIndex = indexPath.item
                self.imageArray.remove(at: indexPath.item)
                self.present(self.imagePicker, animated: true)
            }
            let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
                self.imageArray.remove(at: indexPath.item)
                self.mainView.collectionView.reloadData()
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(edit)
            alert.addAction(delete)
            alert.addAction(cancel)
            present(alert, animated: true)
        } else {
            if imageArray.count < 6 {
                self.imageIndex = imageArray.count - 1
                present(imagePicker, animated: true)
            } else {
                let alert = UIAlertController(title: "안내", message: "사진 추가는 최대 5장입니다.", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default)
                
                alert.addAction(action)
                present(alert, animated: true)
            }
        }
    }
}

extension ProductRegisterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ImageCollectionViewCell =
                collectionView.dequeueReusableCell(withReuseIdentifier:
                                                    ImageCollectionViewCell.stringIdentifier(),
                                                   for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.image.image = imageArray[indexPath.item]
        
        return cell
    }
}

extension ProductRegisterViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard var image = info[.editedImage] as? UIImage else { return }
        
        let isSquare = image.size.width == image.size.height
        
        if isSquare == false {
            if let squareImage = cropSquare(image) {
                image = squareImage
            }
        }
        
        image = image.resize(newWidth: 100)
        imageArray.insert(image, at: imageIndex)
        mainView.collectionView.reloadData()
        mainView.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                             at: .left,
                                             animated: false)
        dismiss(animated: true)
    }
    
    private func cropSquare(_ image: UIImage) -> UIImage? {
        let imageSize = image.size
        let shortLength = imageSize.width < imageSize.height ? imageSize.width : imageSize.height
        let origin = CGPoint(
            x: imageSize.width / 2 - shortLength / 2,
            y: imageSize.height / 2 - shortLength / 2
        )
        let size = CGSize(width: shortLength, height: shortLength)
        let square = CGRect(origin: origin, size: size)
        guard let squareImage = image.cgImage?.cropping(to: square) else {
            return nil
        }
        return UIImage(cgImage: squareImage)
    }
}

extension ProductRegisterViewController: UINavigationControllerDelegate {}
