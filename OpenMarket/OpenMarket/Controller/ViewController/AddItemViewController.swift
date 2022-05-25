//
//  AddItemViewController.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/24.
//

import UIKit

final class AddItemViewController: UIViewController {
    @IBOutlet private weak var itemImageCollectionView: UICollectionView!
    @IBOutlet private weak var curruncySegment: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var discountPriceTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var discriptinTextView: UITextView!
    
    private let imagePicker = UIImagePickerController()
    private var imageArray: [UIImage] = [] {
        didSet {
            itemImageCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
    }
    
    private func setInitialView() {
        navigationItem.setLeftBarButton(makeCancelButton(), animated: true)
        navigationItem.setRightBarButton(makeDoneButton(), animated: true)
        itemImageCollectionView.dataSource = self
        itemImageCollectionView.delegate = self
        imagePicker.delegate = self
        itemImageCollectionView.register(UINib(nibName: "\(ItemImageCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(ItemImageCell.self)")
        setSegmentTextFont()
        setLayout()
        makeKeyboardToolbar()
    }
    
    @objc private func touchCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func touchDoneButton() {
        print("Done")
    }
}
// MARK: - aboutCell
extension AddItemViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageArray.count < 5 {
            return imageArray.count + 1
        } else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ItemImageCell.self)", for: indexPath) as? ItemImageCell else {
            return ItemImageCell()
        }
        
        if indexPath.row == imageArray.count {
            cell.setPlusLabel()
        } else {
            cell.setItemImage(image: imageArray[indexPath.row])
        }
        
        return cell
    }
}

extension AddItemViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if imageArray.count < 5 && indexPath.row == imageArray.count {
            let alert = UIAlertController(title: "", message: "사진 추가", preferredStyle: .actionSheet)
            let albumAction = UIAlertAction(title: "앨범", style: .default){_ in
                self.selectPhoto(where: .photoLibrary)
            }
            let cameraAction = UIAlertAction(title: "카메라", style: .default){_ in
                self.selectPhoto(where: .camera)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(cameraAction)
            alert.addAction(albumAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        }
    }
}

//MARK: - imagePicker
extension AddItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func selectPhoto(where: UIImagePickerController.SourceType) {
        imagePicker.sourceType = `where`
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        guard let image = image?.resizeImage() else { return }
        
        imageArray.append(image)
        dismiss(animated: true)
    }
}

//MARK: - aboutView
extension AddItemViewController {
    private func makeCancelButton() -> UIBarButtonItem {
        let barButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(touchCancelButton))
        barButton.title = "Cancel"
        return barButton
    }
    
    private func makeDoneButton() -> UIBarButtonItem {
        let barButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(touchDoneButton))
        barButton.title = "Done"
        return barButton
    }
    
    private func makeKeyboardToolbar() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .plain, target: self, action: #selector(hideKeyboard))
        barButton.tintColor = .darkGray
        let emptySpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.setItems([emptySpace, barButton], animated: false)
        
        nameTextField.inputAccessoryView = toolBar
        priceTextField.inputAccessoryView = toolBar
        discountPriceTextField.inputAccessoryView = toolBar
        stockTextField.inputAccessoryView = toolBar
        discriptinTextView.inputAccessoryView = toolBar
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    private func setSegmentTextFont() {
        let font = UIFont.preferredFont(forTextStyle: .caption1)
        curruncySegment.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    }
    
    private func setLayout() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: itemSize.widthDimension, heightDimension: itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        itemImageCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
}
