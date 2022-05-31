//
//  UpdateProductViewController.swift
//  OpenMarket
//
//  Created by papri, Tiana on 18/05/2022.
//

import UIKit

class UpdateProductViewController: UIViewController {
    enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
        case image
        case text
        
        var description: String {
            switch self {
            case .image: return "Image"
            case .text: return "Text"
            }
        }
    }
    
    private var product: ProductDetail?
    private var productInput: [String: Any] = [:]
    private let imagePicker = UIImagePickerController()
    private var images: [UIImage] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    private var collectionView: UICollectionView?
    private var collectionViewLayout: UICollectionViewLayout?
    
    lazy var numberPadLayout: NSLayoutConstraint? = {
        guard let cell = collectionView?.cellForItem(at: [1,0]) as? TextCell else {
            return nil
        }
        return cell.baseStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270)
    }()
    
    lazy var defaultPadLayout: NSLayoutConstraint? = {
        guard let cell = collectionView?.cellForItem(at: [1,0]) as? TextCell else {
            return nil
        }
        return cell.baseStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -305)
    }()
    
    lazy var originPadLayout: NSLayoutConstraint? = {
        guard let cell = collectionView?.cellForItem(at: [1,0]) as? TextCell else {
            return nil
        }
        return cell.baseStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    }()
    
    lazy var completionHandler: (Result<Data, NetworkError>) -> Void = { data in
        switch data {
        case .success(_):
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        case .failure(_):
            let alert = Alert().showWarning(title: "경고", message: "실패했습니다", completionHandler: nil)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
            return
        }
    }
    
    func initialize(product: ProductDetail) {
        self.product = product
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        setUpNavigationItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let product = product {
            product.images.forEach { image in
                DataProvider.shared.fetchImage(urlString: image.url) { [self] image in
                    self.images.append(image)
                }
            }
        }
        collectionViewLayout = createLayout()
        
        configureHierarchy(collectionViewLayout: collectionViewLayout ?? UICollectionViewLayout())
        registerCell()
        setUpCollectionView()
        
        setUpImagePicker()
        
        registerNotification()
    }
}

extension UpdateProductViewController {
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardBounds = notification.userInfo?["UIKeyboardBoundsUserInfoKey"]
        guard let keyboardBounds = keyboardBounds as? NSValue else {return}
        
        if keyboardBounds.cgRectValue == CGRect(x: 0.0, y: 0.0, width: 375.0, height: 336.0) {
            defaultPadLayout?.isActive = true
            numberPadLayout?.isActive = false
            originPadLayout?.isActive = false
        } else {
            defaultPadLayout?.isActive = false
            numberPadLayout?.isActive = true
            originPadLayout?.isActive = false
        }
    }
    
    @objc func keyboardWillHide(_ notificationCenter: NotificationCenter) {
        defaultPadLayout?.isActive = false
        numberPadLayout?.isActive = false
        originPadLayout?.isActive = true
    }
}

extension UpdateProductViewController {
    private func setUpNavigationItem() {
        navigationItem.title = product == nil ? "상품등록": "상품수정"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(touchUpDoneButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(touchUpCancelButton))
    }
    
    @objc private func touchUpDoneButton() {
        if images.count == 0 {
            let alertController = Alert().showWarning(title: "이미지를 1개 이상 선택하세요.")
            present(alertController, animated: true)
            return
        }
        
        if let product = product {
            if productInput.keys.contains("descriptions") {
                guard let description = productInput["descriptions"] as? String else {
                    return
                }
                productInput["descriptions"] = description.replacingOccurrences(of: "\n", with: "\\n")
            }
            DataSender.shared.patchProductData(prductIdentifier: product.identifier, productInput: productInput, completionHandler: completionHandler)
            return
        }
        DataSender.shared.postProductData(images: images, productInput: productInput, completionHandler: completionHandler)
    }
    
    @objc private func touchUpCancelButton() {
        dismiss(animated: true)
    }
}

extension UpdateProductViewController {
    private func setUpCollectionView() {
        collectionView?.dataSource = self
        collectionView?.delegate = self
    }
    
    private func registerCell() {
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView?.register(TextCell.self, forCellWithReuseIdentifier: "TextCell")
    }
    
    private func configureHierarchy(collectionViewLayout: UICollectionViewLayout) {
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 100), collectionViewLayout: collectionViewLayout)
        collectionView?.backgroundColor = .systemBackground
        view.addSubview(collectionView ?? UICollectionView())
        layoutCollectionView()
    }
    
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            let section: NSCollectionLayoutSection
            
            if sectionKind == .image {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalWidth(0.4))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            } else if sectionKind == .text {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.6))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
            } else {
                fatalError("Unknown section!")
            }
            
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    private func layoutCollectionView() {
        guard let collectionView = collectionView else {
            return
        }
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

extension UpdateProductViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if product == nil, images.count == 5 {
                return 5
            }
            let itemCount = product == nil ? images.count + 1 : images.count
            return itemCount
        } else if section == 1 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else {
                return UICollectionViewCell()
            }
            
            if let _ = product {
                cell.plusButton.isHidden = true
                cell.imageView.isHidden = false
                cell.imageView.image = images[indexPath.row]
                return cell
            }
            
            if images.count != indexPath.row {
                cell.plusButton.isHidden = true
                cell.imageView.isHidden = false
                guard let image = images[safe: indexPath.row] else {
                    return UICollectionViewCell()
                }
                cell.imageView.image = image
                return cell
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as? TextCell else {
                return UICollectionViewCell()
            }
            
            if let product = product {
                cell.nameTextField.text = product.name
                cell.priceTextField.text = String(product.price)
                cell.discountedPriceTextField.text = String(product.price - product.bargainPrice)
                cell.stockTextField.text = String(product.stock)
                cell.segmentedControl.selectedSegmentIndex = product.currency == "KRW" ? 0 : 1
                
                cell.descriptionTextView.text = product.description.replacingOccurrences(of: "\\n", with: "\n")
            }
            
            setUpDelegate(cell: cell)

            return cell
        }
    }
    
    private func setUpDelegate(cell: TextCell) {
        cell.stockTextField.delegate = self
        cell.nameTextField.delegate = self
        cell.priceTextField.delegate = self
        cell.discountedPriceTextField.delegate = self
        cell.descriptionTextView.delegate = self
        
        cell.delegate = self
    }
}

extension UpdateProductViewController: ValueObserable {
    func observeSegmentIndex(value: String) {
        productInput["currency"] = value
    }
}

extension UpdateProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageCell else { return }
        if !cell.plusButton.isHidden {
            self.present(self.imagePicker, animated: true)
        }
    }
}

extension UpdateProductViewController {
    private func setUpImagePicker() {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
    }
}

extension UpdateProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        
        if let newImage = newImage {
            images.append(newImage)
        }
        
        picker.dismiss(animated: true)
    }
}

extension UpdateProductViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.placeholder {
        case "상품명":
            productInput["name"] = textField.text
        case "상품가격":
            productInput["price"] = Int(textField.text ?? "0")
        case "할인금액":
            productInput["discounted_price"] = Int(textField.text ?? "0")
        case "재고수량":
            productInput["stock"] = Int(textField.text ?? "0")
        default:
            break
        }
        return true
    }
}

extension UpdateProductViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        productInput["descriptions"] = textView.text
    }
}
