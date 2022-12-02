//
//  UpdateViewController.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/29.
//

import UIKit

final class UpdateViewController: UIViewController {
    private let productInformationView: ProductInformationView = ProductInformationView()
    private let imagePickerButton: UIButton = {
        let button: UIButton = UIButton()
        
        button.setTitle("+", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray4
        
        return button
    }()
    private var viewContainers: [ViewContainer] = [] {
        didSet {
            applyViews()
        }
    }
    private var imagePickerActionSheetController: UIAlertController?
    private var isUploading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view = productInformationView
        applyViews()
        setUpDelegate()
        setUpActionSheetController()
        setUpButton()
        setUpNavigationBarButton()
    }
    
    private func setUpDelegate() {
        productInformationView.nameTextField.delegate = self
        productInformationView.priceTextField.delegate = self
        productInformationView.discountedPriceTextField.delegate = self
        productInformationView.stockTextField.delegate = self
        productInformationView.descriptionTextView.delegate = self
    }
    
    private func setUpActionSheetController() {
        imagePickerActionSheetController = {
            let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let albumAlertAction: UIAlertAction = UIAlertAction(title: "앨범", style: .default) { [weak self] (_) in
                self?.presentAlbum()
            }
            let cancelAlertAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel)
            alertController.addAction(albumAlertAction)
            alertController.addAction(cancelAlertAction)
            
            return alertController
        }()
    }
    
    private func setUpButton() {
        imagePickerButton.addTarget(self, action: #selector(presentImagePickerAlertController), for: .touchUpInside)
    }
    
    private func setUpNavigationBarButton() {
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(title: "done",
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(tappedDoneButton))
        let leftBarButton: UIBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(tappedCancelButton))
        
        navigationItem.setRightBarButton(rightBarButton, animated: false)
        navigationItem.setLeftBarButton(leftBarButton, animated: false)
        navigationItem.leftBarButtonItem?.title = "Cancel"
    }
    
    private func applyViews() {
        var snapshot: NSDiffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, ViewContainer>()
        var temporaryViewContainers = viewContainers
        if temporaryViewContainers.count < 5 {
            temporaryViewContainers.append(ViewContainer(view: imagePickerButton))
        }
        snapshot.appendSections([.main])
        snapshot.appendItems(temporaryViewContainers)
        productInformationView.applySnapshot(snapshot)
    }
       
    private func presentAlbum() {
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true)
    }
    
    private func makeProductByInputedData() -> Product? {
        guard let name: String = productInformationView.nameTextField.text,
              let priceText: String = productInformationView.priceTextField.text,
              let price: Double = Double(priceText),
              let description: String = productInformationView.descriptionTextView.text,
              let currency: Currency = .init(productInformationView.currencySegmentedControl.selectedSegmentIndex) else {
            return nil
        }
        
        let discountedPrice: Double = Double(productInformationView.discountedPriceTextField.text ?? "") ?? 0
        let stock: Int = Int(productInformationView.stockTextField.text ?? "") ?? 0
        
        return Product(name: name, description: description, currency: currency, price: price, discountedPrice: discountedPrice, stock: stock)
    }
    
    private func makeImagesByInputedData() -> [UIImage] {
        var images: [UIImage] = []
        let itemCount: Int =  productInformationView.imagePickerCollectionView.numberOfItems(inSection: 0)
        for item in 0..<itemCount {
            if let cell: ImagePickerCell = productInformationView.imagePickerCollectionView.cellForItem(at: IndexPath(item: item, section: 0)) as? ImagePickerCell,
               let imageView: UIImageView = cell.content as? UIImageView,
               let image: UIImage = imageView.image {
                if image.size.width > 300,
                   let resizeImage: UIImage = image.resized(newWidth: 300) {
                    images.append(resizeImage)
                } else {
                    images.append(image)
                }
            }
        }
        return images
    }
    
    @objc
    private func presentImagePickerAlertController(_ sender: UIButton) {
        guard let imagePickerAlertController = imagePickerActionSheetController else {
            return
        }
        present(imagePickerAlertController, animated: true)
    }
    
    @objc
    private func tappedCancelButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc
    private func tappedDoneButton(_ sender: UIBarButtonItem) {
        guard isUploading == false,
              let product: Product = makeProductByInputedData() else {
            return
        }
        let images: [UIImage] = makeImagesByInputedData()
        if images.isEmpty == false {
            let registrationManager = NetworkManager(openMarketAPI: .registration(product: product, images: images))
            registrationManager.network { [weak self] data, error in
                if let error = error {
                    print(error.localizedDescription)
                    self?.isUploading = false
                } else if let _ = data {
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: false)
                    }
                }
            }
            isUploading = true
        }
    }
}

extension UpdateViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let _: NumberTextField = textField as? NumberTextField,
           string.isNumber() == false {
            return false
        } else if let nameTextField: NameTextField = textField as? NameTextField,
                  let text: String = nameTextField.text {
            let lengthOfTextToAdd: Int = string.count - range.length
            let addedTextLength: Int = text.count + lengthOfTextToAdd
            
            return nameTextField.isLessThanOrEqualMaximumLength(addedTextLength)
        }
        return true
    }
}

extension UpdateViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let descriptionTextView: DescriptionTextView = textView as? DescriptionTextView {
            let lengthOfTextToAdd: Int = text.count - range.length
            let addedTextLength: Int = textView.text.count + lengthOfTextToAdd
            
            return descriptionTextView.isLessThanOrEqualMaximumLength(addedTextLength)
        }
        return true
    }
}

extension UpdateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            viewContainers.append(ViewContainer(view: UIImageView(image: image)))
        }
        dismiss(animated: true)
    }
}
