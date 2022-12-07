//
//  ItemViewController.swift
//  OpenMarket
//
//  Created by leewonseok on 2022/12/02.
//

import UIKit

class ItemViewController: UIViewController {
    // MARK: - Property
    var networkManager = NetworkManager()
    var itemImages: [UIImage] = []
    var isPost: Bool = false
    
    let imageScrollView: UIScrollView = {
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

    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemGray6
        return textView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackGroundColor()
        configureNavigation()
        configureImageScrollView()
        configureTextFieldAndTextView()
    }
}

// MARK: - View Constraint
extension ItemViewController {
    func configureImageScrollView() {
        self.view.addSubview(imageScrollView)
        self.imageScrollView.addSubview(imageStackView)

        NSLayoutConstraint.activate([
            self.imageScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.imageScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.imageScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.imageScrollView.heightAnchor.constraint(equalToConstant: 130),

            self.imageStackView.topAnchor.constraint(equalTo: self.imageScrollView.topAnchor),
            self.imageStackView.bottomAnchor.constraint(equalTo: self.imageScrollView.bottomAnchor),
            self.imageStackView.leadingAnchor.constraint(equalTo: self.imageScrollView.leadingAnchor, constant: 5),
            self.imageStackView.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor, constant: -5),
            self.imageStackView.heightAnchor.constraint(equalTo: self.imageScrollView.heightAnchor),
        ])
    }

    func configureTextFieldAndTextView() {
        self.view.addSubview(itemNameTextField)
        self.view.addSubview(priceStackView)
        self.view.addSubview(discountedPriceTextField)
        self.view.addSubview(stockTextField)
        self.view.addSubview(descriptionTextView)
        self.priceStackView.addSubview(priceTextField)
        self.priceStackView.addSubview(currencySegmentedControl)

        NSLayoutConstraint.activate([
            self.itemNameTextField.topAnchor.constraint(equalTo: self.imageScrollView.bottomAnchor, constant: 15),
            self.itemNameTextField.leadingAnchor.constraint(equalTo: self.imageScrollView.leadingAnchor),
            self.itemNameTextField.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor),
            self.itemNameTextField.heightAnchor.constraint(equalToConstant: 35),

            self.priceStackView.topAnchor.constraint(equalTo: self.itemNameTextField.bottomAnchor, constant: 10),
            self.priceStackView.leadingAnchor.constraint(equalTo: self.imageScrollView.leadingAnchor),
            self.priceStackView.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor),
            self.priceStackView.heightAnchor.constraint(equalToConstant: 35),

            self.currencySegmentedControl.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor),
            self.priceTextField.leadingAnchor.constraint(equalTo: self.imageScrollView.leadingAnchor),
            self.priceTextField.trailingAnchor.constraint(equalTo: self.currencySegmentedControl.leadingAnchor),

            self.discountedPriceTextField.topAnchor.constraint(equalTo: self.priceStackView.bottomAnchor, constant: 10),
            self.discountedPriceTextField.leadingAnchor.constraint(equalTo: self.imageScrollView.leadingAnchor),
            self.discountedPriceTextField.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor),
            self.discountedPriceTextField.heightAnchor.constraint(equalToConstant: 35),

            self.stockTextField.topAnchor.constraint(equalTo: self.discountedPriceTextField.bottomAnchor, constant: 10),
            self.stockTextField.leadingAnchor.constraint(equalTo: self.imageScrollView.leadingAnchor),
            self.stockTextField.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor),
            self.stockTextField.heightAnchor.constraint(equalToConstant: 35),

            self.descriptionTextView.topAnchor.constraint(equalTo: self.stockTextField.bottomAnchor, constant: 10),
            self.descriptionTextView.leadingAnchor.constraint(equalTo: self.imageScrollView.leadingAnchor),
            self.descriptionTextView.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor),
            self.descriptionTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - Method
extension ItemViewController {
    @objc func configureNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action:
            #selector(doneButtonTapped))
    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }

    @objc func doneButtonTapped() {
        guard let parameter = createParameter() else { return }

        self.isPost = true
        LoadingController.showLoading()
        networkManager.addItem(parameter: parameter, images: itemImages) { result in
            LoadingController.hideLoading()

            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.showAlert(title: "성공", message: "등록에 성공했습니다", actionTitle: "확인", dismiss: true)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(title: "실패", message: "등록에 실패했습니다", actionTitle: "확인", dismiss: false)
                }
            }

            self.isPost = false
        }
    }

    func showAlert(title: String, message: String, actionTitle: String, dismiss: Bool){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if dismiss {
            alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
                self.dismiss(animated: true)
            }))
        } else {
            alert.addAction(UIAlertAction(title: actionTitle, style: .default))
        }

        present(alert, animated: true)
    }
    
    func configureBackGroundColor() {
        self.view.backgroundColor = .systemBackground
    }
    
    func createParameter() -> [String:Any]? {
        let priceText = priceTextField.text ?? "0"
        let discountedPriceText = discountedPriceTextField.text ?? "0"
        let stockText = stockTextField.text ?? "0"
        
        guard isPost == false else {
            showAlert(title: "경고", message: "처리 중 입니다.", actionTitle: "확인", dismiss: false)
            return nil
        }
        
        guard itemImages.count > 0 else {
            showAlert(title: "경고", message: "이미지를 등록해주세요.", actionTitle: "확인", dismiss: false)
            return nil
        }
        
        guard let itemNameText =  itemNameTextField.text,
              itemNameText.count > 2 else {
            showAlert(title: "경고", message: "제목을 3글자 이상 입력해주세요.", actionTitle: "확인", dismiss: false)
            return nil
        }
        
        
        guard let price = Double(priceText),
              let discountPrice = Double(discountedPriceText),
              let stock = Int(stockText) else {
            showAlert(title: "경고", message: "유효한 숫자를 입력해주세요", actionTitle: "확인", dismiss: false)
            return nil
        }
        
        guard let descriptionText = descriptionTextView.text,
              descriptionText.count <= 1000 else {
            showAlert(title: "경고", message: "내용은 1000자 이하만 등록가능합니다.", actionTitle: "확인", dismiss: false)
            return nil
        }
        
        let parameter: [String: Any] = ["name": itemNameText,
                                     "price": price,
                                     "currency": currencySegmentedControl.selectedSegmentIndex == 0
                                     ? Currency.krw.rawValue: Currency.usd.rawValue,
                                     "discounted_price": discountPrice,
                                     "stock": stock,
                                     "description": descriptionText,
                                     "secret": NetworkManager.secret]
        return parameter
    }
}

