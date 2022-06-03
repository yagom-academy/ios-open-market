//
//  RegistrationViewController.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/24.
//

import UIKit

final class RegistrationViewController: UIViewController, UINavigationControllerDelegate {
    private let imagePicker = UIImagePickerController()
    private var imageArray = [UIImage]()
    private let doneButton = UIBarButtonItem()
    private var networkManager = NetworkManager<ProductsList>(session: URLSession.shared)
    private var networkImageArray = [ImageInfo]()
    private let productDetailView = ProductDetailView()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    private let entireScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewDelegate()
        setView()
        setLayout()
        configureBarButton()
    }
    
    private func setView() {
        self.view.addSubview(entireScrollView)
        entireScrollView.addSubview(collectionView)
        entireScrollView.addSubview(productDetailView)
        
        self.view.backgroundColor = .white
        productDetailView.backgroundColor = .white
        
        collectionView.register(RegistrationViewCell.self, forCellWithReuseIdentifier: RegistrationViewCell.identifier)
    }
    
    private func setViewDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
        imagePicker.delegate = self
    }
    
    private func configureBarButton() {
        self.navigationItem.leftBarButtonItem?.title = "Cancel"
        self.title = "상품등록"
        self.navigationItem.rightBarButtonItem = doneButton
        
        doneButton.title = "Done"
        doneButton.style = .done
        doneButton.target = self
        doneButton.action = #selector(executePOST)
    }
    
    private func setLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        productDetailView.translatesAutoresizingMaskIntoConstraints = false
        entireScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            entireScrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            entireScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            entireScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            entireScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            entireScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            collectionView.widthAnchor.constraint(equalTo: entireScrollView.widthAnchor),
            collectionView.leadingAnchor.constraint(equalTo: entireScrollView.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: entireScrollView.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: entireScrollView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: productDetailView.topAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 160),
            
            productDetailView.widthAnchor.constraint(equalTo: entireScrollView.widthAnchor),
            productDetailView.leadingAnchor.constraint(equalTo: entireScrollView.leadingAnchor),
            productDetailView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            productDetailView.trailingAnchor.constraint(equalTo: entireScrollView.trailingAnchor),
            productDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func pickImage(_ sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController()
        
        let importFromAlbum = UIAlertAction(title: Alert.album, style: .default) { _ in
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let takePhoto = UIAlertAction(title: Alert.camera, style: .default) { _ in
            self.imagePicker.sourceType = .camera
            self.imagePicker.cameraCaptureMode = .photo
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: Alert.cancel, style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        actionSheet.addAction(importFromAlbum)
        actionSheet.addAction(takePhoto)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension RegistrationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imageCount = imageArray.count + 1
        return imageCount < 5 ? imageCount : 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegistrationViewCell.identifier, for: indexPath) as? RegistrationViewCell else {
            return UICollectionViewCell()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickImage(_:)))
        
        cell.contentView.addSubview(cell.imageView)
        cell.imageView.isUserInteractionEnabled = true
        cell.imageView.addGestureRecognizer(tapGesture)
        
        if imageArray.count > indexPath.row {
            let image = imageArray[indexPath.row]
            cell.imageView.image = image
            cell.label.text = ""
            cell.imageView.isUserInteractionEnabled = false
        }
        
        return cell
    }
}

extension RegistrationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
}

extension RegistrationViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
                return
            }
            
            let imageCapacity = image.checkImageCapacity()
            
            if imageCapacity > 300 {
                let resizedImage = image.resize(newWidth: 80)
                self.imageArray.append(resizedImage)
                
                guard let imageData = resizedImage.jpegData(compressionQuality: 1) else {
                    return
                }
                
                let imageInfo = ImageInfo(fileName: "marisol.jpeg", data: imageData, type: "jpeg")
                self.networkImageArray.append(imageInfo)
            } else {
                self.imageArray.append(image)
                guard let imageData = image.jpegData(compressionQuality: 1) else {
                    return
                }
                
                let imageInfo = ImageInfo(fileName: "marisol.jpeg", data: imageData, type: "jpeg")
                self.networkImageArray.append(imageInfo)
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension RegistrationViewController {
    @objc private func executePOST() {
        let params = productDetailView.makeProduct()
        
        self.networkManager.execute(with: .productRegistration, httpMethod: .post, params: params, images: self.networkImageArray) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.showSuccessAlert()
                }

            case .failure:
                DispatchQueue.main.async {
                    self.showFailureAlert()
                }
            }
        }
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Alert
extension RegistrationViewController {
    private func showSuccessAlert() {
        let alert = UIAlertController(title: Alert.saveSuccessTitle, message: Alert.saveSuccessMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alert.ok, style: .default))
        self.present(alert, animated: true)
    }
    
    private func showFailureAlert() {
        let alert = UIAlertController(title: Alert.saveFailureTitle, message: Alert.saveFailureMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alert.ok, style: .default))
        self.present(alert, animated: true)
    }
}
