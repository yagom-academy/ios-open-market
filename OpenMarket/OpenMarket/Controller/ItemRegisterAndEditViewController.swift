//
//  ItemRegisterAndEditViewController.swift
//  OpenMarket
//
//  Created by yeha on 2022/01/20.
//

import UIKit

class ItemRegisterAndEditViewController: UIViewController {

//    private var scrollViewBottomAnchor: NSLayoutConstraint?

    let imagePicker = UIImagePickerController()
    var images = [UIImage(named: "mbp14-silver"),
                  UIImage(named: "mbp14-silver"),
                  UIImage(named: "mbp14-spacegray"),
                  UIImage(named: "mbp14-spacegray"),
                  UIImage(systemName: "plus")]

    @objc func pickImage() {
        self.present(self.imagePicker, animated: true)
    }
    let scrollContentView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 130, height: 130)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isDirectionalLockEnabled = true
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()
    let nameInputTextView = InputInformationTextView(type: .name)
    let priceStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.distribution = .equalSpacing
        stackview.alignment = .fill
        stackview.spacing = 10
        return stackview
    }()
    let priceInputTextView: InputInformationTextView = {
        let textView = InputInformationTextView(type: .price)
        textView.keyboardType = .decimalPad
        return textView
    }()
    let currencySegmentedControl: UISegmentedControl = {
        let items = [Currency.KRW.rawValue, Currency.USD.rawValue]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.borderColor = UIColor.systemGray3.cgColor
        let selectedText = [NSAttributedString.Key.backgroundColor: UIColor.white]
        let defaultText = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.setTitleTextAttributes(selectedText, for: .selected)
        segmentedControl.setTitleTextAttributes(defaultText, for: .normal)
        segmentedControl.addTarget(
            self,
            action: #selector(submitForm),
            for: .valueChanged
        )
        return segmentedControl
    }()
    let bargainPriceInputTextView: InputInformationTextView = {
        let textView = InputInformationTextView(type: .bargainPrice)
        textView.keyboardType = .decimalPad
        return textView
    }()
    let stockInputTextView: InputInformationTextView = {
        let textView = InputInformationTextView(type: .stock)
        textView.keyboardType = .numberPad
        return textView
    }()
    let descriptionInputTextView = InputInformationTextView(type: .description)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupNavigationBar()
        setupViews()
        addKeyboardNotificationObservers()
        addKeyboardDismissGestureRecognizer()
    }

    private func setupDelegate() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(submitForm))
        self.navigationItem.rightBarButtonItem = doneButton
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissForm))
        self.navigationItem.leftBarButtonItem = dismissButton
    }

    @objc private func submitForm() {
        print("submitForm")
        RegistrationManager().registerItem()
    }

    @objc private func dismissForm() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ItemRegisterAndEditViewController {

    private func setupViews() {
        priceStackView.addArrangedSubview(priceInputTextView)
        priceStackView.addArrangedSubview(currencySegmentedControl)
        scrollContentView.addSubview(photoCollectionView)
        scrollContentView.addSubview(nameInputTextView)
        scrollContentView.addSubview(priceStackView)
        scrollContentView.addSubview(bargainPriceInputTextView)
        scrollContentView.addSubview(stockInputTextView)
        scrollContentView.addSubview(descriptionInputTextView)
        view.addSubview(scrollContentView)
        view.backgroundColor = .white

        setupScrollContentView()
        setupPhotoCollectionView()
        setupStackView()
        setupTextView()
    }

    private func setupScrollContentView() {
        scrollContentView.backgroundColor = .systemBackground
//        scrollViewBottomAnchor = scrollContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        scrollViewBottomAnchor?.isActive = true

        NSLayoutConstraint.activate([
            scrollContentView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollContentView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollContentView.contentLayoutGuide.topAnchor.constraint(equalTo: photoCollectionView.topAnchor),
            scrollContentView.contentLayoutGuide.bottomAnchor.constraint(equalTo: descriptionInputTextView.bottomAnchor)
        ])

    }

    private func setupPhotoCollectionView() {
        photoCollectionView.frame = view.bounds
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 15),
            photoCollectionView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -15),
            photoCollectionView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.2)
        ])
    }

    private func setupStackView() {
        NSLayoutConstraint.activate([
            priceStackView.topAnchor.constraint(equalTo: nameInputTextView.bottomAnchor, constant: 10),
            priceStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            priceStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            priceStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
        ])
    }

    private func setupTextView() {
        NSLayoutConstraint.activate([
            nameInputTextView.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor, constant: 10),
            nameInputTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            nameInputTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),

            priceInputTextView.leadingAnchor.constraint(equalTo: priceStackView.leadingAnchor),
            priceInputTextView.widthAnchor.constraint(greaterThanOrEqualTo: priceStackView.widthAnchor, multiplier: 0.7),

            currencySegmentedControl.leadingAnchor.constraint(equalTo: priceInputTextView.trailingAnchor, constant: 10),
            currencySegmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            currencySegmentedControl.widthAnchor.constraint(greaterThanOrEqualTo: priceStackView.widthAnchor, multiplier: 0.2),

            bargainPriceInputTextView.topAnchor.constraint(equalTo: priceStackView.bottomAnchor, constant: 10),
            bargainPriceInputTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            bargainPriceInputTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),

            stockInputTextView.topAnchor.constraint(equalTo: bargainPriceInputTextView.bottomAnchor, constant: 10),
            stockInputTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            stockInputTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),

            descriptionInputTextView.topAnchor.constraint(equalTo: stockInputTextView.bottomAnchor, constant: 10),
            descriptionInputTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            descriptionInputTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
    }
}

extension ItemRegisterAndEditViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        if indexPath.row == 0 {
            cell.addGestureRecognizer(tap)
        }
        cell.image = images[indexPath.item]
        return cell
    }
}

// MARK: ImagePicker
extension ItemRegisterAndEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            images.append(newImage)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Keyboard
extension ItemRegisterAndEditViewController {
    private func addKeyboardNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollContentView.contentInset.bottom = keyboardFrame.height / 2
        scrollContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardFrame.height).isActive = true

//        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
//        UIView.animate(withDuration: duration) {
//            self.view.layoutIfNeeded()
//        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInset: UIEdgeInsets = .zero
        scrollContentView.contentInset = contentInset
        scrollContentView.scrollIndicatorInsets = contentInset
        scrollContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

//        guard let userInfo = notification.userInfo,
//              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
//        UIView.animate(withDuration: duration) {
//            self.view.layoutIfNeeded()
//        }
    }

    private func removeKeyboardNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func addKeyboardDismissGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
