//
//  RegisterEditViewController.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/24.
//

import UIKit

final class RegisterEditViewController: UIViewController{
    
    private enum Constant {
        static let rightNavigationButtonText = "Done"
        static let leftNavigationButtonText = "Cancel"
    }
    
    enum Mode {
        case add
        case edit
        
        var navigationItemTitle: String {
            switch self{
            case .add:
                return "상품등록"
            case .edit:
                return "상품수정"
            }
        }
    }
    
    var mode: Mode = .add
    let picker = UIImagePickerController()
    
    private lazy var rightNavigationButton = UIBarButtonItem(
        title: Constant.rightNavigationButtonText,
        style: .plain,
        target: self,
        action: #selector(registerEditViewRightBarButtonTapped)
    )
    
    private lazy var leftNavigationButton: UIBarButtonItem = UIBarButtonItem(
        title: Constant.leftNavigationButtonText,
        style: .plain,
        target: self,
        action: #selector(registerEditViewLeftBarButtonTapped)
    )
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [addImageButton])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 10
        view.alignment = .leading
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var addImageButton: UIButton = {
        let imageButton = UIButton()
        let image = UIImage(systemName: "plus")
        
        imageButton.setImage(image, for: .normal)
        imageButton.backgroundColor = .systemGray5
        imageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        
        return imageButton
    }()
    
    @objc private func addImage() {
        let alert = UIAlertController(
            title: "상품 이미지 추가",
            message: "",
            preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) {
            (action) in
            self.openLibrary()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    private func openLibrary() {
        picker.sourceType   = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationTitle()
        setConstraint()
        picker.delegate = self
    }
    
    private func addImageToStackView(image: UIImage){
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        imageView.image = image
        horizontalStackView.addArrangedSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        horizontalStackView.setNeedsDisplay()
    }
}

extension RegisterEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("errror")
    }
        
    addImageToStackView(image: selectedImage)
    picker.dismiss(animated: true)
    }
    
}

// MARK: - Method
extension RegisterEditViewController {
    
    private func setNavigationTitle() {
        navigationItem.title = mode.navigationItemTitle
        navigationItem.rightBarButtonItem = rightNavigationButton
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = leftNavigationButton
    }
    
    private func setConstraint() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        ])
        
        scrollView.addSubview(horizontalStackView)
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            horizontalStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addImageButton.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor),
            addImageButton.widthAnchor.constraint(equalTo: addImageButton.heightAnchor)
        ])
    }
}

// MARK: - Action Method
extension RegisterEditViewController {
    
    @objc private func registerEditViewRightBarButtonTapped() {
        
    }
    
    @objc private func registerEditViewLeftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
