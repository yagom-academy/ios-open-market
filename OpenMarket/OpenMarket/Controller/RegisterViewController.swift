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
    @IBOutlet weak var textFieldsStackView: TextFieldsStackView!
    var addheaderView: ImageAddHeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
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
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        guard inputValidation() else {
            return
        }
        guard let product = textFieldsStackView.createRegistration() else {
            return
        }
        let imageFiles = createImageFiles()
        requestRegistration(product: product, imageFiles: imageFiles)
    }
    
}

extension RegisterViewController {
    private func requestRegistration(product: ProductRegistration, imageFiles: [ImageFile]) {
        guard let request = createRequest(params: product, images: imageFiles) else {
            showAlert(message: Message.badRequest) {
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        let networkManager = NetworkManager()
        networkManager.fetch(request: request, decodingType: Product.self) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.showAlert(message: Message.completeProductRegistration) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: error.localizedDescription) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func createRequest<T: Encodable>(params: T, images: [ImageFile]) -> URLRequest? {
        let networkManager = NetworkManager()
        let requestResult = networkManager.requestRegister(params: params, images: images)
        switch requestResult {
        case .success(let request):
            return request
        case .failure:
            return nil
        }
    }
    
    private func createImageFiles() -> [ImageFile] {
        var imageFiles = [ImageFile]()
        
        images.forEach { image in
            guard let imageData = image.jpegData(compressionQuality: 1) else {
                self.showAlert(message: Message.unknownError)
                return
            }
            let imageFile = ImageFile(name: UUID().uuidString, data: imageData, type: .jpeg)
            imageFiles.append(imageFile)
        }
        return imageFiles
    }
    
    private func inputValidation() -> Bool {
        let isValidImagesCount = images.count > .zero
        let isValidNameCount = textFieldsStackView.nameTextField.text?.count ?? .zero >= 3
        let isValidPriceCount = (textFieldsStackView.priceTextField.text?.count ?? .zero) > .zero
        let isMaintainMiniMumDescriptionCount = textFieldsStackView.descriptionTextView.text.count >= 10
        let isMaintainMaxiMumDescriptionCount = textFieldsStackView.descriptionTextView.text.count < 1000
        
        guard isValidImagesCount else {
            showAlert(message: Message.minimumImageCount)
            return false
        }
        guard isValidNameCount else {
            showAlert(message: Message.minimumNameCount)
            return false
        }
        guard isValidPriceCount else {
            showAlert(message: Message.minimumPriceCount)
            return false
        }
        guard isMaintainMiniMumDescriptionCount else {
            showAlert(message: Message.minimumDescriptionCount)
            return false
        }
        guard isMaintainMaxiMumDescriptionCount else {
            showAlert(message: Message.maximumDescriptionCount)
            return false
        }
        return true
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
        headerView.delegate = self
        addheaderView = headerView
        return headerView
    }
}

extension RegisterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        images.remove(at: indexPath.item)
        collectionView.performBatchUpdates {
            collectionView.deleteItems(at: [IndexPath(item: indexPath.item, section: 0)])
        } completion: { _ in
            self.addheaderView?.updateLabelText(imageCount: self.images.count)
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
            self.addheaderView?.updateLabelText(imageCount: self.images.count)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension RegisterViewController: ImageAddHeaderViewDelegate {
    func tappedAddButton() {
        guard images.count != 5 else {
            self.showAlert(message: Message.maximumImageCount)
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
}
