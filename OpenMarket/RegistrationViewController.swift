//
//  RegistrationViewController.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/08/01.
//

import UIKit

class RegistrationViewController: UIViewController {

    private let imagePickerController = UIImagePickerController()
    private var imageCount = 0
    private var images = [UIImage]()

    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(registerProduct), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(goBackMainViewController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var imageAddButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: CollectionViewNamespace.plus.name)
        button.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.backgroundColor = .systemGray5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let productPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let discountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인금액"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let stockTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: [Currency.KRW.name, Currency.USD.name])
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    private let descriptionTextView: UITextView = {
       let textView = UITextView()
        return textView
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        self.title = "상품등록"
        
        view.addSubview(imageScrollView)
        view.addSubview(textStackView)
        
        imageScrollView.addSubview(imageStackView)
        imageStackView.addArrangedSubview(imageAddButton)
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        textStackView.addArrangedSubview(productNameTextField)
        textStackView.addArrangedSubview(priceStackView)
        textStackView.addArrangedSubview(discountedPriceTextField)
        textStackView.addArrangedSubview(stockTextField)
        textStackView.addArrangedSubview(descriptionTextView)
        
        priceStackView.addArrangedSubview(productPriceTextField)
        priceStackView.addArrangedSubview(segmentedControl)
        
        setConstrant()
    }
    
    @objc private func goBackMainViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func registerProduct() {
        
        let params: [String: Any?] = ["name": productNameTextField.text, "descriptions": descriptionTextView.text, "price": productPriceTextField.text, "currency": choiceCurrency()?.name]
        
        NetworkManager().postProduct(params: params, images: images)
        resetRegistrationPage()
    }
    
    private func resetRegistrationPage() {
        images = []
        imageCount = 0
        imageStackView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        imageStackView.addArrangedSubview(imageAddButton)
        productNameTextField.text = ""
        productPriceTextField.text = ""
        discountedPriceTextField.text = ""
        stockTextField.text = ""
        descriptionTextView.text = ""
        segmentedControl.selectedSegmentIndex = 0
    }
    
    private func choiceCurrency() -> Currency? {
        return Currency.init(rawValue: segmentedControl.selectedSegmentIndex)
    }
    
    @objc private func addImage() {
        present(imagePickerController, animated: true)
    }
    
    private func setConstrant() {
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageScrollView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageAddButton.heightAnchor.constraint(equalToConstant: 100),
            imageAddButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: 10),
            textStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            textStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            textStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        ])
        
        imageScrollView.setContentHuggingPriority(.required, for: .vertical)
        descriptionTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if imageCount == 4 {
            imageAddButton.isHidden = true
        }
        
        var selectedImage: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = originalImage
        }
                
        if imageCount < 5 {
            let imageView = UIImageView()
            imageView.image = selectedImage
            imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            imageStackView.insertArrangedSubview(imageView, at: 0)
            imageCount += 1
        } else {
            print("5장만 넣을 수 있습니다.")
        }
        
        guard let addedImage = selectedImage else { return }
        images.append(addedImage)
        
        imagePickerController.dismiss(animated: true)
    }
}
