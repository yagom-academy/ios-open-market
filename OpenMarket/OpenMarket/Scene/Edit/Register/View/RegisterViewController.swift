//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/24.
//

import UIKit

final class RegisterViewController: UIViewController {
    private lazy var editView = EditView(frame: view.frame)
    private let viewModel = RegisterViewModel()
    
    override func loadView() {
        super.loadView()
        view.addSubview(editView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarItems()
        setUpViewModel()
        setUpKeyboardNotification()
        viewModel.setUpDefaultImage()
    }
    
    private func setUpBarItems() {
        editView.setUpBarItem(title: "상품등록")
        editView.navigationBarItem.leftBarButtonItem?.target = self
        editView.navigationBarItem.leftBarButtonItem?.action = #selector(didTapCancelButton)
    }
    
    private func setUpViewModel() {
        viewModel.datasource = makeDataSource()
        viewModel.delegate = self
    }
    
    private func setUpKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        editView.topScrollView.contentInset.bottom = keyboardFrame.size.height
        
        let firstResponder = editView.firstResponder
        
        if let textView = firstResponder as? UITextView {
            editView.topScrollView.scrollRectToVisible(textView.frame, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        editView.topScrollView.contentInset = contentInset
        editView.topScrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func didTapCancelButton() {
        self.dismiss(animated: true)
    }
}

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        return nil
    }
}

extension RegisterViewController {
    private func makeDataSource() -> UICollectionViewDiffableDataSource<RegisterViewModel.Section, ImageInfo> {
        let dataSource = UICollectionViewDiffableDataSource<RegisterViewModel.Section, ImageInfo>(
            collectionView: editView.collectionView,
            cellProvider: { (collectionView, indexPath, image) -> UICollectionViewCell in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProductsHorizontalCell.identifier,
                    for: indexPath) as? ProductsHorizontalCell else {
                    return UICollectionViewCell()
                }
                
                cell.updateImage(imageInfo: image)
                cell.delegate = self

                return cell
            })
        return dataSource
    }
}

extension RegisterViewController: AlertDelegate {
    func showAlertRequestError(with error: Error) {
        print("")
    }
}

extension RegisterViewController: CellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func addButtonTaped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let captureImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        viewModel.insert(image: captureImage)
        self.dismiss(animated: true, completion: nil)
    }
}
