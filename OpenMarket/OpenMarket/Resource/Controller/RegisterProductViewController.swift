//
//  RegisterProductViewController.swift
//  OpenMarket
//
//  Created by baem, minii on 2022/12/02.
//

import UIKit

class RegisterProductViewController: UIViewController {
    var selectedImage: [UIImage?] = []
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            RegisterCollectionImageCell.self,
            forCellWithReuseIdentifier: RegisterCollectionImageCell.identifier
        )
        return collectionView
    }()
    
    let doneToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        return toolbar
    }()
    
    lazy var productNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "상품명"
        
        return textField
    }()
    
    lazy var productPriceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "상품가격"
        
        return textField
    }()
    
    lazy var discountPriceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "할인금액"
        
        return textField
    }()
    
    lazy var stockTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "재고수량"
        
        return textField
    }()
    
    let currencySegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: Currency.allCases.map(\.rawValue))
        
        return segment
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textview = UITextView()
        textview.text = "국회는 국민의 보통·평등·직접·비밀선거에 의하여 선출된 국회의원으로 구성한다. 법률이 헌법에 위반되는 여부가 재판의 전제가 된 경우에는 법원은 헌법재판소에 제청하여 그 심판에 의하여 재판한다.\n\n법률은 특별한 규정이 없는 한 공포한 날로부터 20일을 경과함으로써 효력을 발생한다. 대통령은 헌법과 법률이 정하는 바에 의하여 국군을 통수한다. 헌법재판소 재판관은 정당에 가입하거나 정치에 관여할 수 없다."
        textview.font = .preferredFont(forTextStyle: .title3)
        textview.inputAccessoryView = doneToolbar
        textview.autocorrectionType = .no
        textview.keyboardType = .default
        textview.autocapitalizationType = .none
        textview.spellCheckingType = .no
        
        return textview
    }()
    
    @objc func didTapped() {
        view.frame.origin.y = .zero
        view.endEditing(true)
    }
     
    lazy var segmentStackview: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.addArrangedSubview(productPriceTextField)
        stackView.addArrangedSubview(currencySegment)
        stackView.spacing = 8
        currencySegment.widthAnchor.constraint(equalTo: productPriceTextField.widthAnchor, multiplier: 0.30).isActive = true
        
        return stackView
    }()
    
    lazy var totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        [
            productNameTextField,
            segmentStackview,
            discountPriceTextField,
            stockTextField
        ].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTappedDoneButton)
        )
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "상품등록"
        
        [
            stockTextField,
            productNameTextField,
            productPriceTextField,
            discountPriceTextField
        ].forEach {
            $0.delegate = self
        }
        
        descriptionTextView.delegate = self
        
        [collectionView, totalStackView, descriptionTextView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        view.addSubview(totalStackView)
        view.addSubview(descriptionTextView)
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.2),
            
            totalStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            totalStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            totalStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: totalStackView.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            descriptionTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    @objc func didTappedDoneButton() {
        
    }
}

extension RegisterProductViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if selectedImage.count < 5 {
            return selectedImage.count + 1
        }
        
        return selectedImage.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegisterCollectionImageCell.identifier, for: indexPath) as? RegisterCollectionImageCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.item == selectedImage.count {
            cell.configureButtonStyle()
        } else {
            cell.itemImageView.image = selectedImage[indexPath.item]
        }
        
        return cell
    }
}

extension RegisterProductViewController: UICollectionViewDelegateFlowLayout { }

extension RegisterProductViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let viewSize = view.frame.size
        let contentWidth = viewSize.width / 3 - 10
        
        return CGSize(width: contentWidth, height: contentWidth)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let filteredImages = selectedImage.filter { $0 != nil }
        
        if filteredImages.count == 5 {
            return
        }
        
        if indexPath.item == filteredImages.count {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension RegisterProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage.append(image)
        }
        
        collectionView.reloadData()
        picker.dismiss(animated: true)
    }
    
}

extension RegisterProductViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        view.frame.origin.y = -(textField.frame.origin.y + view.safeAreaInsets.top)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.frame.origin.y = 0
        view.endEditing(true)
        return true
    }
}

extension RegisterProductViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        let height = (textView.frame.origin.y - view.safeAreaInsets.top - navigationController!.navigationBar.frame.height)
        view.frame.origin.y = -(height + doneToolbar.bounds.height + view.safeAreaInsets.bottom)
    }
}
