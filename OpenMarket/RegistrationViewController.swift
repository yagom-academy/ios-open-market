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

    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        self.title = "상품등록"
        
        view.addSubview(imageScrollView)
        imageScrollView.addSubview(imageStackView)
        imageStackView.addArrangedSubview(imageAddButton)
        setConstrant()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
    }
    
    @objc private func addImage() {
        present(imagePickerController, animated: true)
    }
    
    private func setConstrant() {
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageAddButton.heightAnchor.constraint(equalToConstant: 100),
            imageAddButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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

        imagePickerController.dismiss(animated: true)
    }
}
