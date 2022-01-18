//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/10.
//

import UIKit

class RegisterViewController: UIViewController {

    var images = [UIImage]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setNotificationCenter()
    }
    
    func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        registerXib()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func registerXib() {
        let cellNib = UINib(nibName: ImageCell.nibName, bundle: .main)
        collectionView.register(cellNib, forCellWithReuseIdentifier: ImageCell.identifier)
        
        let headerNib = UINib(nibName: ImageAddHeaderView.nibName, bundle: .main)
        collectionView.register(
            headerNib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ImageAddHeaderView.identifier)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension RegisterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCell.identifier,
            for: indexPath
        ) as? ImageCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = images[indexPath.item]
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ImageAddHeaderView.identifier,
            for: indexPath
        ) as? ImageAddHeaderView else {
            return UICollectionReusableView()
        }
        return headerView
    }
}

extension RegisterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        images.remove(at: indexPath.item)
        collectionView.performBatchUpdates {
            collectionView.deleteItems(at: [IndexPath(item: indexPath.item, section: 0)])
        } completion: { _ in
            NotificationCenter.default.post(name: .editImageCountLabel, object: self.images.count)
        }
    }
}

extension RegisterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.safeAreaLayoutGuide.layoutFrame.width / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let width = collectionView.safeAreaLayoutGuide.layoutFrame.width / 3
        return CGSize(width: width, height: width)
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tappedAddButton),
            name: .addButton, object: nil
        )
    }
    
    @objc private func tappedAddButton() {
        guard images.count != 5 else {
            self.showAlert(message: "이미지는 최대 5개까지 첨부할 수 있어요")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        guard let selectedImage = editedImage ?? originalImage else {
            return
        }
        images.append(selectedImage.compress())
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: [IndexPath(item: images.count - 1, section: 0)])
        } completion: { _ in
            NotificationCenter.default.post(name: .editImageCountLabel, object: self.images.count)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
