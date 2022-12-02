//
//  ItemAddViewController.swift
//  OpenMarket
//
//  Created by leewonseok on 2022/11/25.
//

import UIKit

class ItemAddViewController: UIViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigation()
        configureScrollView()
        configureAddView()
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
        print("Button Tapped")
    }

    func configureAddView() {
        self.addView.addSubview(addButton)

        self.addView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.addView.heightAnchor.constraint(equalToConstant: 150).isActive = true

        self.addButton.topAnchor.constraint(equalTo: self.addView.topAnchor).isActive = true
        self.addButton.bottomAnchor.constraint(equalTo: self.addView.bottomAnchor).isActive = true
        self.addButton.leadingAnchor.constraint(equalTo: self.addView.leadingAnchor).isActive = true
        self.addButton.trailingAnchor.constraint(equalTo: self.addView.trailingAnchor).isActive = true
    }

    func configureScrollView() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(imageStackView)

        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.scrollView.heightAnchor.constraint(equalToConstant: 150).isActive = true

        self.imageStackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.imageStackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        self.imageStackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.imageStackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.imageStackView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor).isActive = true

        self.imageStackView.addArrangedSubview(addView)

    }
}

extension ItemAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func presentAlbum(){
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
            self.imageStackView.insertArrangedSubview(UIImageView(image: image), at: 0)
        }
        dismiss(animated: true, completion: nil)
    }
}
