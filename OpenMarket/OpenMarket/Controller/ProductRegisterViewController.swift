//
//  ProductRegisterViewController.swift
//  OpenMarket
//
//  Created by Lingo, Quokka on 2022/05/24.
//

import UIKit

final class ProductRegisterViewController: UIViewController {
  private var keyboardSize: CGRect?
  private var images = [UIImage]()
  
  private let containerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 20.0
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let imageScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  private let imageStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 10.0
    return stackView
  }()
  
  private lazy var addImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "add")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.isUserInteractionEnabled = true
    let gesture = UITapGestureRecognizer(target: self, action: #selector(addImageViewDidTap))
    imageView.addGestureRecognizer(gesture)
    return imageView
  }()
  
  private let productInputStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 5.0
    return stackView
  }()
  
  private let nameTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.font = .preferredFont(forTextStyle: .subheadline)
    textField.placeholder = "상품명"
    return textField
  }()
  
  private let productPriceStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fill
    stackView.spacing = 5.0
    return stackView
  }()
  
  private let priceTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.keyboardType = .numberPad
    textField.font = .preferredFont(forTextStyle: .subheadline)
    textField.placeholder = "상품가격"
    return textField
  }()
  
  private let currencySegment: UISegmentedControl = {
    let segment = UISegmentedControl(items: ["KRW", "USD"])
    segment.selectedSegmentIndex = 0
    return segment
  }()
  
  private let discountedPriceTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.keyboardType = .numberPad
    textField.font = .preferredFont(forTextStyle: .subheadline)
    textField.placeholder = "할인금액"
    return textField
  }()
  
  private let stockTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.keyboardType = .numberPad
    textField.font = .preferredFont(forTextStyle: .subheadline)
    textField.placeholder = "재고수량"
    return textField
  }()
  
  private lazy var descriptionsTextView: UITextView = {
    let textView = UITextView()
    textView.textColor = .black
    textView.font = .preferredFont(forTextStyle: .subheadline)
    let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownAction))
    gesture.direction = .down
    textView.addGestureRecognizer(gesture)
    textView.delegate = self
    return textView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.configureNavigationItem()
    NotificationCenter.default.addObserver(self, selector: #selector(textViewDidTap), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(textViewDidTap), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc func swipeDownAction(_ sender: UISwipeGestureRecognizer) {
    self.view.endEditing(true)
  }
  
  @objc func textViewDidTap(notification: Notification) {
    guard let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
             as? NSValue)?.cgRectValue else {
      return
    }
    self.keyboardSize = keyboardSize
  }
  
  @objc func addImageViewDidTap(_ sender: UIImageView) {
    self.presentActionSheet()
  }
  
  private func presentActionSheet() {
    let alert = UIAlertController(title: "선택", message: nil, preferredStyle: .actionSheet)
    let cancel = UIAlertAction(title: "취소", style: .cancel)
    let album = UIAlertAction(title: "앨범", style: .default) { [weak self] _ in
      self?.presentAlbum()
    }
    alert.addAction(cancel)
    alert.addAction(album)
    self.present(alert, animated: true)
  }
  
  private func presentAlbum() {
    let pickerController = UIImagePickerController()
    pickerController.sourceType = .photoLibrary
    pickerController.delegate = self
    pickerController.allowsEditing = true
    self.present(pickerController, animated: true)
  }
}

// MARK: - UI

private extension ProductRegisterViewController {
  func configureUI() {
    self.view.backgroundColor = .systemBackground
    self.view.addSubview(containerStackView)
    self.containerStackView.addArrangedSubview(imageScrollView)
    self.containerStackView.addArrangedSubview(productInputStackView)
    self.containerStackView.addArrangedSubview(descriptionsTextView)
    
    self.imageScrollView.addSubview(imageStackView)
    self.imageStackView.addArrangedSubview(addImageView)
    
    self.productPriceStackView.addArrangedSubview(priceTextField)
    self.productPriceStackView.addArrangedSubview(currencySegment)
    
    self.productInputStackView.addArrangedSubview(nameTextField)
    self.productInputStackView.addArrangedSubview(productPriceStackView)
    self.productInputStackView.addArrangedSubview(discountedPriceTextField)
    self.productInputStackView.addArrangedSubview(stockTextField)
    
    NSLayoutConstraint.activate([
      containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
      containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
      
      imageScrollView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.16),
      
      imageStackView.topAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.topAnchor),
      imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.bottomAnchor),
      imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.leadingAnchor),
      imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.contentLayoutGuide.trailingAnchor),
      imageStackView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor),
      
      addImageView.widthAnchor.constraint(equalTo: addImageView.heightAnchor),
      
      priceTextField.widthAnchor.constraint(equalTo: currencySegment.widthAnchor, multiplier: 2.0)
    ])
  }
  
  func configureNavigationItem() {
    self.title = "상품등록"
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .cancel,
      target: self,
      action: #selector(closeButtonDidTap))
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(closeButtonDidTap))
  }
  
  @objc func closeButtonDidTap() {
    guard let product = createProductForm() else { return }
    
    let service = APINetworkService(urlSession: URLSession.shared)
    service.registerProduct(product)
    self.dismiss(animated: true)
  }
  
  func createProductForm() -> ProductRequest? {
    guard let productName = nameTextField.text,
          let productPrice = priceTextField.text,
          let discountedPrice = discountedPriceTextField.text,
          let productStock = stockTextField.text,
          let description = descriptionsTextView.text
    else { return nil }
    
    return ProductRequest(
      name: productName,
      price: productPrice,
      currency: currencySegment.selectedSegmentIndex == .zero ? .krw : .usd,
      discountedPrice: discountedPrice,
      stock: productStock,
      description: description,
      images: images
    )
  }
}

// MARK: - Delegate

extension ProductRegisterViewController: UITextViewDelegate {
  func textView(
    _ textView: UITextView,
    shouldChangeTextIn range: NSRange,
    replacementText text: String
  ) -> Bool {
    guard let previousText = textView.text else { return false }
    let newLength = previousText.count + text.count - range.length
    return newLength <= 1000
  }

  func textViewDidBeginEditing(_ textView: UITextView) {
    UIView.animate(withDuration: 0.2) {
      guard let keyboardheight = self.keyboardSize?.height else { return }
      self.view.transform = CGAffineTransform(translationX: 0.0, y: -keyboardheight * 0.8)
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    UIView.animate(withDuration: 0.2) {
      self.view.transform = .identity
    }
  }
}

extension ProductRegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    if let image = info[.editedImage] as? UIImage {
      let resizedImage = image.resize(with: imageStackView.frame.height)
      self.images.append(resizedImage)
      
      let imageView = UIImageView()
      imageView.contentMode = .scaleToFill
      imageView.image = resizedImage
      imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
      self.imageStackView.insertArrangedSubview(imageView, at: imageStackView.arrangedSubviews.count - 1)
      if imageStackView.arrangedSubviews.count == 6 {
        self.addImageView.isHidden = true
      }
    }
    self.dismiss(animated: true)
  }
}
