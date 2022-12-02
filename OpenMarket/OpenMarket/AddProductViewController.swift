//
//  AddProductViewController.swift
//  OpenMarket
//
//  Created by Aaron, Jpush on 2022/11/25.
//

import UIKit

final class AddProductViewController: UIViewController {
    var updateDelegate: CollectionViewUpdateDelegate?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    let addProductButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.contentMode = .center
        
        let image = UIImage(systemName: "plus")
        button.setImage(image, for: .normal)
        return button
    }()
    
    let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .black
        textField.borderStyle = .roundedRect
        textField.placeholder = "상품명"
        return textField
    }()
    
    let productPriceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.textColor = .systemGray
        textField.tintColor = .black
        textField.borderStyle = .roundedRect
        textField.placeholder = "상품가격"
        
        return textField
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    let bargainPriceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .black
        textField.borderStyle = .roundedRect
        textField.placeholder = "할인금액"
        return textField
    }()
    
    let stockTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .black
        textField.borderStyle = .roundedRect
        textField.placeholder = "재고수량"
        return textField
    }()
    
    let currencySegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["KRW", "USD"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        return control
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 17.0)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configure()
        setUpUI()
    }
    
    func configure() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(tappedCancelButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(tappedDoneButton))
        
        self.view.addSubview(scrollView)
        self.view.addSubview(productNameTextField)
        self.view.addSubview(priceStackView)
        self.view.addSubview(bargainPriceTextField)
        self.view.addSubview(stockTextField)
        self.view.addSubview(descriptionTextView)
        
        scrollView.addSubview(imageStackView)
        scrollView.addSubview(addProductButton)
        
        addProductButton.addTarget(self, action: #selector(tappedPlusButton), for: .touchUpInside)
        
        self.priceStackView.addArrangedSubview(productPriceTextField)
        self.priceStackView.addArrangedSubview(currencySegmentedControl)
    }
    
    func setUpUI() {
        let safeArea = self.view.safeAreaLayoutGuide
        let inset: CGFloat = 4
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: inset),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: inset),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -inset),
            scrollView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.2),
            
            imageStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            addProductButton.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.2),
            addProductButton.widthAnchor.constraint(equalTo: addProductButton.heightAnchor),
            addProductButton.leadingAnchor.constraint(equalTo: imageStackView.trailingAnchor, constant: inset),
            addProductButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: inset),

            productNameTextField.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: inset),
            productNameTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: inset),
            productNameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -inset),
            
            priceStackView.topAnchor.constraint(equalTo: productNameTextField.bottomAnchor, constant: inset),
            priceStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: inset),
            priceStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -inset),
            
            productPriceTextField.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.7),
            
            bargainPriceTextField.topAnchor.constraint(equalTo: priceStackView.bottomAnchor, constant: inset),
            bargainPriceTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: inset),
            bargainPriceTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -inset),
            
            stockTextField.topAnchor.constraint(equalTo: bargainPriceTextField.bottomAnchor, constant: inset),
            stockTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: inset),
            stockTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -inset),
            
            descriptionTextView.topAnchor.constraint(equalTo: stockTextField.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: inset),
            descriptionTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -inset),
            descriptionTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    @objc
    func tappedDoneButton(_ sender: Any) {
        let name = productNameTextField.text ?? ""
        let description = descriptionTextView.text ?? ""
        let currency: Currency = currencySegmentedControl.selectedSegmentIndex == 0 ? .KRW : .USD
        let price = Double(productPriceTextField.text ?? "0") ?? 0
        let bargainPrice = Double(bargainPriceTextField.text ?? "0") ?? 0
        let stock = Int(stockTextField.text ?? "0") ?? 0
        
        var imageArray: [UIImage] = []
        let imageViewArray = imageStackView.subviews as? [UIImageView] ?? []
        imageViewArray.forEach { imageView in
            if let picture: UIImage = imageView.image {
                let transSize = CGSize(width: picture.size.width / 10, height: picture.size.height / 10)
                let resizeImage = picture.resizeImageTo(size: transSize)
                imageArray.append(resizeImage)
            }
        }

        print(imageArray)
        
        let product = Product(name: name,
                              description: description,
                              currency: currency,
                              price: price,
                              bargainPrice: bargainPrice,
                              discountedPrice: price - bargainPrice,
                              stock: stock,
                              secret: Constant.password
        )
        
        let manager = NetworkManager()
        manager.postProductLists(params: product, images: imageArray) {
            print("보냄")
            DispatchQueue.main.sync {
                self.updateDelegate?.updateCollectionView()
                self.dismiss(animated: true)
            }
        }

        print("?")
        // post
    }
    
    @objc
    func tappedPlusButton(_ sender: Any) {
        if self.imageStackView.subviews.count != 5 {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            
            self.present(picker, animated: true)
        }
    }
    
    @objc
    func tappedCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension AddProductViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) {
            if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                let imageView = UIImageView(image: img)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                self.imageStackView.addArrangedSubview(imageView)
                
                if self.imageStackView.subviews.count == 5 {
                    self.addProductButton.isHidden = true
                    
                    imageView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: 4).isActive = true
                }
                
                imageView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2).isActive = true
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
            } else {
                print("image nil")
            }
        }
    }
}

extension AddProductViewController: UINavigationControllerDelegate {
    
}


extension UIImage {
    
    func resizeImageTo(size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
