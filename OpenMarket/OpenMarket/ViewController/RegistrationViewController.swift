//
//  RegistrationViewController.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/08/01.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: Properties
    
    private let imagePickerController = UIImagePickerController()
    private var imageCount = Registraion.initailNumber
    private var images = [UIImage]()

    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle(Registraion.done, for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(registerProduct), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(Registraion.cancel, for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(goBackMainViewController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: Registraion.scrollViewInset, left: Registraion.scrollViewInset, bottom: Registraion.scrollViewInset, right: Registraion.scrollViewInset)
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = Registraion.stackViewSpacing
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
        textField.placeholder = Registraion.productName
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let productPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Registraion.productPrice
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let discountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Registraion.discountedPrice
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let stockTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Registraion.stock
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: [Currency.KRW.name, Currency.USD.name])
        segment.selectedSegmentIndex = Registraion.initailNumber
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
        stackView.spacing = Registraion.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = Registraion.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        self.title = Registraion.registraionProduct
        
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
        setViewGesture()
        regiterForkeyboardNotification()
    }
    
    // MARK: Method
    
    @objc private func goBackMainViewController() {
        removeRegisterForKeyboardNotification()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func registerProduct() {
        
        let params: [String: Any?] = [Params.productName: productNameTextField.text, Params.productDescription: descriptionTextView.text, Params.productPrice: productPriceTextField.text, Params.currency: choiceCurrency()?.name]
        
        NetworkManager().postProduct(params: params, images: images) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.showCustomAlert(title: "🥳", message: "상품등록이 정상적으로 완료되었습니다!")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                self.showCustomAlert(title: "🤔", message: error.localizedDescription)
                }
            }
        }
        resetRegistrationPage()
    }
    
    private func resetRegistrationPage() {
        images = []
        imageCount = Registraion.initailNumber
        imageStackView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        imageStackView.addArrangedSubview(imageAddButton)
        productNameTextField.text = Registraion.textClear
        productPriceTextField.text = Registraion.textClear
        discountedPriceTextField.text = Registraion.textClear
        stockTextField.text = Registraion.textClear
        descriptionTextView.text = Registraion.textClear
        segmentedControl.selectedSegmentIndex = Registraion.initailNumber
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
            imageScrollView.heightAnchor.constraint(equalToConstant: Registraion.imageSize)
        ])
        
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageAddButton.heightAnchor.constraint(equalToConstant: Registraion.imageSize),
            imageAddButton.widthAnchor.constraint(equalToConstant: Registraion.imageSize)
        ])
        
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: Registraion.textStackViewPositiveSize),
            textStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Registraion.textStackViewNagativeSize),
            textStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Registraion.textStackViewNagativeSize),
            textStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Registraion.textStackViewPositiveSize)
        ])
        
        imageScrollView.setContentHuggingPriority(.required, for: .vertical)
        descriptionTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    private func setViewGesture() {
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDownAction))
           view.addGestureRecognizer(tapGesture)
       }
       
       @objc private func keyboardDownAction(_ sender: UISwipeGestureRecognizer) {
           self.view.endEditing(true)
           descriptionTextView.contentInset.bottom = Registraion.descriptionTextViewInset
       }
       
       private func regiterForkeyboardNotification() {
           NotificationCenter.default.addObserver(self, selector: #selector(keyBoardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
       }
       
       @objc private func keyBoardShow(notification: NSNotification) {
           guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary else {
               return
           }
           
           guard let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
               return
           }
           
           let keyboardRectangle = keyboardFrame.cgRectValue
           let keyboardHeight = keyboardRectangle.height
           
           descriptionTextView.contentInset.bottom += keyboardHeight
       }
       
       private func removeRegisterForKeyboardNotification() {
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
       }
    
    func showCustomAlert(title: String, message: String) {
           let okTitle = "확인"

           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let okButton = UIAlertAction(title: okTitle, style: .default)
        alertController.addAction(okButton)
           
           present(alertController, animated: true)
       }
   }

// MARK: Extension

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        var selectedImage: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = originalImage
        }
                
        if imageCount <= Registraion.maxImageCount {
            let imageView = UIImageView()
            imageView.image = selectedImage
            imageView.heightAnchor.constraint(equalToConstant: Registraion.imageSize).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: Registraion.imageSize).isActive = true
            imageStackView.insertArrangedSubview(imageView, at: Registraion.firstIndex)
            imageCount += 1
        } else {
            imagePickerController.dismiss(animated: true)
            showCustomAlert(title: "⚠️", message: "이미지는 최대 5장까지 등록할 수 있습니다")
            return
        }
        
        guard let addedImage = selectedImage else { return }
        images.append(addedImage)
        
        imagePickerController.dismiss(animated: true)
    }
}
