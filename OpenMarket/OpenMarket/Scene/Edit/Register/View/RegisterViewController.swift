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
    
    @objc private func didTapCancelButton() {
        self.dismiss(animated: true)
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
    func buttonTaped() {
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
