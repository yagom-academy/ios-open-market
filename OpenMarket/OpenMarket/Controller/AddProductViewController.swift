//  Created by Aejong, Tottale on 2022/11/22.

import UIKit

final class AddProductViewController: UIViewController {
    
    weak var delegate: UploadDelegate?
    let addView = ProductAddView()
    let imagePicker = UIImagePickerController()
    var imageCount = 0
    var textFieldConstraint: NSLayoutConstraint?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureImagePicker()
        configureNavigationBar()
        configureDoneButton()
        configureCancelButton()
        configureAddImageButton()
        configureView()
        initializeHideKeyBoard()
    }
    
    private func configureView() {
        self.view = addView
        addView.descriptionTextView.delegate = self
    }
    
    private func configureNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.shadowColor = .clear
        self.navigationItem.title = "상품등록"
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func configureDoneButton() {
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self,
                                       action: #selector(doneButtonPressed))
        self.navigationItem.rightBarButtonItem = doneItem
    }
    
    private func configureCancelButton() {
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                                         action: #selector(cancelButtonPressed))
        self.navigationItem.leftBarButtonItem = cancelItem
    }
    
    private func configureAddImageButton() {
        self.addView.photoAddButton.addTarget(self, action: #selector(imageAddButtonPressed), for: UIControl.Event.touchUpInside)
    }
    
    private func configureImagePicker() {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.delegate = self
    }
    
    @objc private func cancelButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func doneButtonPressed() {
        self.uploadNewProduct()
    }
    
    @objc private func imageAddButtonPressed(_ sender: UIButton) {
        guard imageCount < 5 else { return }
        self.present(self.imagePicker, animated: true)
    }
}

extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.addView.addImageView(with: image)
        }
        imageCount += 1
        dismiss(animated: true, completion: nil)
    }

}

extension AddProductViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.addView.imageScrollView.isHidden = true
        textFieldConstraint =  self.addView.textFieldStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        textFieldConstraint?.isActive = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textFieldConstraint?.isActive = false
        self.addView.imageScrollView.isHidden = false
    }
    
    func initializeHideKeyBoard() {
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyBoard))
        self.addView.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyBoard() {
        self.addView.endEditing(true)
    }
}

extension AddProductViewController {
    
    private func fetchNewProductInfo() -> NewProductInfo? {
        guard let name = self.addView.productNameTextField.text, !name.isEmpty,
              let newProductDescription = self.addView.descriptionTextView.text, !newProductDescription.isEmpty,
              let price = Int(self.addView.productPriceTextField.text ?? "0"),
              let currency = self.addView.productPriceSegment.titleForSegment(at: self.addView.productPriceSegment.selectedSegmentIndex)
        else { return nil }
        
        let discountedPrice = Int(self.addView.productBargainPriceTextField.text ?? "0")
        let stock = Int(self.addView.productStockTextField.text ?? "0")
        
        let newProductInfo = NewProductInfo(name: name, newProductDescription: newProductDescription, price: price, currency: currency, discountedPrice: discountedPrice, stock: stock)
        
        return newProductInfo
    }
    
    private func fetchImage() -> [UIImage]? {
        let images: [UIImage] = self.addView.imageStackView.subviews.compactMap { $0 as? UIImageView }.compactMap { $0.image }
        guard images.count > 0 else { return nil }
        return images
    }
    
    private func uploadNewProduct() {
        guard let newProductInfo = fetchNewProductInfo(),
              let images = fetchImage()
        else { return }
    
        DispatchQueue.global().async {
            ProductNetworkManager.shared.postNewProduct(params: newProductInfo, images: images) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.delegate?.isUploaded(true)
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self.delegate?.isUploaded(false)
                    }
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}
