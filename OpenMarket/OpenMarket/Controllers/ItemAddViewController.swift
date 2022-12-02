//
//  ItemAddViewController.swift
//  OpenMarket
//
//  Created by leewonseok on 2022/11/25.
//

import UIKit

class ItemAddViewController: UIViewController {
    let networkManager = NetworkManager()
    var itemImages: [UIImage] = []
    
    lazy var addView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(presentAlbum), for: .touchUpInside)
        return button
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.contentMode = .scaleToFill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    let itemNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "상품명"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    let priceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "상품가격"
        textField.borderStyle = .roundedRect
        return textField
        
    }()
    
    let currencySegmentedControl: UISegmentedControl = {
        let item = ["KRW", "USD"]
        let segmentedControl = UISegmentedControl(items: item)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    let discountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "할인금액"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let stockTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "재고수량"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let desciptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemGray6
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureScrollView()
        configureAddView()
        configureTextFieldAndTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = .systemBackground
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.view.backgroundColor = .systemBackground
    }
    
    private func configureNavigation() {
        self.navigationItem.title = "상품등록"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func doneButtonTapped() {
        guard itemImages.count > 0 else {
            return
        }

        guard let itemNameText =  itemNameTextField.text,
              itemNameText.count > 2 else {
            return
        }

        guard let desciptionText = desciptionTextView.text,
              desciptionText.count < 1000 else {
            return
        }

        let params: [String: Any] = ["name": itemNameText,
                                     "price": Double(priceTextField.text!) ?? 0,
                                     "currency": currencySegmentedControl.selectedSegmentIndex == 0 ? "KRW" : "USD",
                                     "discounted_price": Double(discountedPriceTextField.text!) ?? 0,
                                     "stock": Int(stockTextField.text!) ?? 0,
                                     "description": desciptionText,
                                     "secret": NetworkManager.secret]

        networkManager.addItem(params: params, images: itemImages) { result in
            switch result {
            case .success(let item):
                print(item)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureAddView() {
        self.addView.addSubview(addButton)
        
        self.addView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        self.addView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        self.addButton.topAnchor.constraint(equalTo: self.addView.topAnchor).isActive = true
        self.addButton.bottomAnchor.constraint(equalTo: self.addView.bottomAnchor).isActive = true
        self.addButton.leadingAnchor.constraint(equalTo: self.addView.leadingAnchor).isActive = true
        self.addButton.trailingAnchor.constraint(equalTo: self.addView.trailingAnchor).isActive = true
    }
    
    func configureScrollView() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(imageStackView)
        
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        self.scrollView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        self.imageStackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.imageStackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        self.imageStackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 5).isActive = true
        self.imageStackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -5).isActive = true
        self.imageStackView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor).isActive = true
        
        self.imageStackView.addArrangedSubview(addView)
        
    }
    
    func configureTextFieldAndTextView() {
        self.view.addSubview(itemNameTextField)
        self.view.addSubview(priceStackView)
        self.view.addSubview(discountedPriceTextField)
        self.view.addSubview(stockTextField)
        self.view.addSubview(desciptionTextView)
        self.priceStackView.addSubview(priceTextField)
        self.priceStackView.addSubview(currencySegmentedControl)
        
        self.itemNameTextField.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 15).isActive = true
        self.itemNameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        self.itemNameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        self.itemNameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.priceStackView.topAnchor.constraint(equalTo: itemNameTextField.bottomAnchor, constant: 10).isActive = true
        self.priceStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        self.priceStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        self.priceStackView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.currencySegmentedControl.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        self.priceTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        self.priceTextField.trailingAnchor.constraint(equalTo: currencySegmentedControl.leadingAnchor).isActive = true
        
        self.discountedPriceTextField.topAnchor.constraint(equalTo: priceStackView.bottomAnchor, constant: 10).isActive = true
        self.discountedPriceTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        self.discountedPriceTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        self.discountedPriceTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.stockTextField.topAnchor.constraint(equalTo: discountedPriceTextField.bottomAnchor, constant: 10).isActive = true
        self.stockTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        self.stockTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        self.stockTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.desciptionTextView.topAnchor.constraint(equalTo: stockTextField.bottomAnchor, constant: 10).isActive = true
        self.desciptionTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        self.desciptionTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        self.desciptionTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
}

extension ItemAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func presentAlbum(){
        guard itemImages.count < 5 else {
            // 나중에 함수 분리
            let alert = UIAlertController(title: "경고", message: "5개 이하의 이미지만 등록할 수 있습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: false)
            return
        }
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        
        present(vc, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            self.itemImages.append(image)
            self.imageStackView.insertArrangedSubview(UIImageView(image: image), at: 0)
        }
        dismiss(animated: true, completion: nil)
    }
}

